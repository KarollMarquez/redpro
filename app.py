"""RedPro: red profesional sobre una base de datos de grafos (Neo4j) + Flask.
Ejecutar:  python init_db.py   y luego   python app.py"""
import os, re, time, secrets
from functools import wraps
from neo4j import GraphDatabase
from flask import Flask, render_template, request, redirect, session, flash, abort, jsonify
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY", "cambia-esta-clave-larga-y-secreta")
app.config.update(SESSION_COOKIE_SAMESITE="Lax", SESSION_COOKIE_HTTPONLY=True)
URI = os.getenv("NEO4J_URI", "bolt://localhost:7687")
AUTH = (os.getenv("NEO4J_USER", "neo4j"), os.getenv("NEO4J_PASS", "12345678"))
_driver = None

# ---------- acceso a Neo4j ----------
def driver():
    global _driver
    if _driver is None:
        _driver = GraphDatabase.driver(URI, auth=AUTH)
    return _driver

def q(cypher, p=None):                    # consulta: devuelve una lista de diccionarios
    with driver().session() as s:
        return [r.data() for r in s.run(cypher, p or {})]

def q1(cypher, p=None):                   # consulta que devuelve una sola fila (o None)
    r = q(cypher, p)
    return r[0] if r else None

def x(cypher, p=None):                    # escritura (CREATE, SET, DELETE...)
    with driver().session() as s:
        s.run(cypher, p or {}).consume()

def nuevo_id(etiqueta):
    return q1(f"MATCH (n:{etiqueta}) RETURN coalesce(max(n.id), 0) + 1 AS id")["id"]

# ---------- consultas Cypher (se muestran tal cual en la app) ----------
# Un patrón como (a)-[:CONECTA_CON]-(b) se lee: "a está conectado con b".
S = {
"sugeridos": """MATCH (yo:Usuario {id: $u}), (p:Usuario)
WHERE p <> yo AND NOT (yo)-[:CONECTA_CON]-(p)
WITH yo, p,
  size([(yo)-[:CONECTA_CON]-(c:Usuario)-[:CONECTA_CON]-(p) | c]) AS comunes,
  size([(yo)-[:TIENE_HABILIDAD]->(h)<-[:TIENE_HABILIDAD]-(p) | h]) AS compartidas
WHERE comunes + compartidas > 0
RETURN p.id AS id, p.nombre AS nombre, p.titular AS titular, comunes, compartidas
ORDER BY comunes * 2 + compartidas DESC LIMIT 6""",
"similares": """MATCH (yo:Usuario {id: $u})-[:TIENE_HABILIDAD]->(h)<-[:TIENE_HABILIDAD]-(p:Usuario)
WHERE p <> yo
RETURN p.id AS id, p.nombre AS nombre, p.titular AS titular,
       count(h) AS n, collect(h.nombre) AS hab
ORDER BY n DESC LIMIT 6""",
"comunes": """MATCH (a:Usuario {id: $u})-[:CONECTA_CON]-(p:Usuario)-[:CONECTA_CON]-(b:Usuario {id: $o})
RETURN DISTINCT p.id AS id, p.nombre AS nombre, p.titular AS titular""",
"empleos": """MATCH (yo:Usuario {id: $u}), (e:Empresa)-[:PUBLICA]->(o:Oferta)
RETURN o.id AS id, o.titulo AS titulo, o.descripcion AS descripcion,
  e.id AS empresa_id, e.nombre AS empresa,
  size([(o)-[:REQUIERE]->(h) | h]) AS req,
  size([(o)-[:REQUIERE]->(h)<-[:TIENE_HABILIDAD]-(yo) | h]) AS cumple,
  size([(e)<-[:TRABAJA_EN]-(c:Usuario)-[:CONECTA_CON]-(yo) | c]) AS conocidos,
  size([(yo)-[:POSTULA_A]->(o) | o]) AS postulado""",
"hab_oferta": """MATCH (o:Oferta {id: $o})-[:REQUIERE]->(h:Habilidad)
RETURN h.nombre AS nombre, EXISTS { (:Usuario {id: $u})-[:TIENE_HABILIDAD]->(h) } AS tengo""",
"candidatos": """MATCH (o:Oferta {id: $o})-[:REQUIERE]->(h)<-[:TIENE_HABILIDAD]-(p:Usuario)
WITH p, count(DISTINCT h) AS cumple
RETURN p.id AS id, p.nombre AS nombre, p.titular AS titular, cumple,
  size([(:Empresa {id: $e})<-[:TRABAJA_EN]-(c:Usuario)-[:CONECTA_CON]-(p) | c]) AS conexiones
ORDER BY cumple DESC, conexiones DESC LIMIT 3""",
"proyectos_rel": """MATCH (p:Proyecto {id: $p}), (p2:Proyecto)
WHERE p2 <> p
WITH p2,
  size([(p)-[:USA_TECNOLOGIA]->(h)<-[:USA_TECNOLOGIA]-(p2) | h]) AS tecnologias,
  size([(p)<-[:PARTICIPA_EN]-(u)-[:PARTICIPA_EN]->(p2) | u]) AS miembros
WHERE tecnologias + miembros > 0
RETURN p2.id AS id, p2.nombre AS nombre, tecnologias, miembros""",
"influyentes": """MATCH (p:Usuario)
RETURN p.id AS id, p.nombre AS nombre, p.titular AS titular,
       size([(p)-[:CONECTA_CON]-(c) | c]) AS conexiones
ORDER BY conexiones DESC LIMIT 5""",
"demanda": """MATCH (h:Habilidad)<-[:REQUIERE]-(o:Oferta)
RETURN h.nombre AS nombre, count(o) AS ofertas,
       size([(h)<-[:TIENE_HABILIDAD]-(u) | u]) AS profesionales
ORDER BY ofertas DESC LIMIT 8""",
"ruta": """// Para una persona, cambia :Empresa por :Usuario
MATCH (a:Usuario {id: $u}), (b:Empresa {id: $d}),
  p = shortestPath((a)-[:CONECTA_CON|TRABAJA_EN|PARTICIPA_EN|PUBLICA|POSTULA_A*..10]-(b))
RETURN [n IN nodes(p) | {t: labels(n)[0], n: coalesce(n.nombre, n.titulo)}] AS nodos,
       [r IN relationships(p) | type(r)] AS rels""",
"grafo": """MATCH (n) RETURN n;           // todos los nodos
MATCH (a)-[r]->(b) RETURN a, r, b;  // todas las relaciones""",
"colaboradores": """MATCH (p:Proyecto {id: $p})-[:USA_TECNOLOGIA]->(h)<-[:TIENE_HABILIDAD]-(u:Usuario)
WHERE NOT (u)-[:PARTICIPA_EN]->(p)
RETURN u.id AS id, u.nombre AS nombre, count(h) AS coincidencias
ORDER BY coincidencias DESC LIMIT 3""",
"comunidades": """MATCH (a:Usuario)-[:CONECTA_CON]->(b:Usuario)
RETURN a.id AS a, b.id AS b
// Luego Python agrupa a quienes se alcanzan entre sí (componentes conectados).
// En producción: la librería Graph Data Science de Neo4j (algoritmo Louvain).""",
}

# ---------- algoritmos ----------
ETIQ, LETRA = {"u": "Usuario", "e": "Empresa"}, {"Usuario": "u", "Empresa": "e", "Proyecto": "p", "Oferta": "o"}

def camino(u, tipo, destino):
    """Ruta más corta: la calcula Neo4j con shortestPath."""
    r = q1(S["ruta"].replace(":Empresa", ":" + ETIQ[tipo]), {"u": u, "d": destino})
    if not r:
        return None
    return [{"t": LETRA[n["t"]], "n": n["n"], "rel": r["rels"][i - 1] if i else None} for i, n in enumerate(r["nodos"])]

def comunidades():
    """Comunidad = grupo de usuarios que se alcanzan entre sí por CONECTA_CON (union-find)."""
    nom = {r["id"]: r["nombre"] for r in q("MATCH (u:Usuario) RETURN u.id AS id, u.nombre AS nombre")}
    padre = {i: i for i in nom}
    def raiz(i):
        while padre[i] != i:
            padre[i] = padre[padre[i]]
            i = padre[i]
        return i
    for r in q("MATCH (a:Usuario)-[:CONECTA_CON]->(b:Usuario) RETURN a.id AS a, b.id AS b"):
        padre[raiz(r["a"])] = raiz(r["b"])
    grupos = {}
    for i in padre:
        grupos.setdefault(raiz(i), []).append(i)
    out = []
    for ids in grupos.values():
        if len(ids) < 2:
            continue
        h = q("""MATCH (u:Usuario)-[:TIENE_HABILIDAD]->(h) WHERE u.id IN $ids
                 RETURN h.nombre AS nombre, count(*) AS n ORDER BY n DESC LIMIT 3""", {"ids": ids})
        out.append({"miembros": [nom[i] for i in ids], "habilidades": [r["nombre"] for r in h]})
    return sorted(out, key=lambda c: -len(c["miembros"]))

def empleos(u):
    r = q(S["empleos"], {"u": u})
    for o in r:
        o["pct"] = round(100 * o["cumple"] / o["req"]) if o["req"] else 0
        o["hab"] = q(S["hab_oferta"], {"u": u, "o": o["id"]})
        o["cand"] = q(S["candidatos"], {"o": o["id"], "e": o["empresa_id"]})
    return sorted(r, key=lambda o: (-o["pct"], -o["conocidos"]))

# ---------- seguridad y validaciones ----------
EMAIL = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]{2,}$")
COMUNES = {"12345678", "password", "qwerty123", "contraseña", "abc12345", "demo123"}
INTENTOS = {}                              # correo -> (fallos, hora del último fallo)

def validar_registro(f):
    e, c = [], f.get("clave", "")
    if len(f.get("nombre", "").strip()) < 2:
        e.append("Escribe tu nombre completo.")
    if not EMAIL.match(f.get("email", "").strip()):
        e.append("El correo no tiene un formato válido.")
    if not (8 <= len(c) <= 64 and re.search(r"[A-Z]", c) and re.search(r"[a-z]", c)
            and re.search(r"\d", c) and re.search(r"[^A-Za-z0-9]", c)) or c.lower() in COMUNES:
        e.append("La contraseña debe tener de 8 a 64 caracteres, con mayúscula, minúscula, número y símbolo, y no ser una clave común.")
    if c != f.get("clave2", ""):
        e.append("Las contraseñas no coinciden.")
    return e

def bloqueado(email):                      # 5 fallos seguidos = 5 minutos de espera
    n, t = INTENTOS.get(email, (0, 0))
    if n >= 5 and time.time() - t >= 300:
        INTENTOS.pop(email, None)
        return False
    return n >= 5

def csrf():                                # token que impide que otros sitios envíen formularios por ti
    session.setdefault("csrf", secrets.token_hex(16))
    return session["csrf"]

app.jinja_env.globals["csrf"] = csrf       # disponible también dentro de los macros de las plantillas

@app.before_request
def verificar_csrf():
    if request.method == "POST" and request.form.get("_csrf") != session.get("csrf"):
        abort(400)

# ---------- sesión ----------
def login(f):
    @wraps(f)
    def w(*a, **k):
        if "uid" not in session or not q1("MATCH (u:Usuario {id: $id}) RETURN u.id AS id", {"id": session["uid"]}):
            session.clear()
            return redirect("/")
        return f(*a, **k)
    return w

@app.context_processor
def ctx():
    yo = q1("MATCH (u:Usuario {id: $id}) RETURN u.id AS id, u.nombre AS nombre, u.titular AS titular", {"id": session["uid"]}) if "uid" in session else None
    return dict(yo=yo, sql=S, csrf=csrf)

def volver(msg=None, cat="ok"):
    if msg:
        flash(msg, cat)
    return redirect(request.referrer or "/inicio")

@app.route("/")
def entrada():
    if "uid" in session:
        return redirect("/inicio")
    return render_template("auth.html", modo=request.args.get("modo", "ingresar"))

@app.post("/ingresar")
def ingresar():
    email = request.form["email"].strip().lower()
    if bloqueado(email):
        flash("Demasiados intentos fallidos. Espera 5 minutos e inténtalo de nuevo.", "err")
        return redirect("/")
    u = q1("MATCH (u:Usuario {email: $e}) RETURN u.id AS id, u.clave AS clave", {"e": email})
    if u and check_password_hash(u["clave"], request.form["clave"]):
        INTENTOS.pop(email, None)
        session["uid"] = u["id"]
        return redirect("/inicio")
    INTENTOS[email] = (INTENTOS.get(email, (0, 0))[0] + 1, time.time())
    flash("Correo o contraseña incorrectos.", "err")
    return redirect("/")

@app.post("/registro")
def registro():
    f = request.form
    email = f["email"].strip().lower()
    errores = validar_registro(f)
    if errores:
        for e in errores:
            flash(e, "err")
        return redirect("/?modo=registro")
    if q1("MATCH (u:Usuario {email: $e}) RETURN u.id AS id", {"e": email}):
        flash("Ese correo ya tiene cuenta. Ingresa con él.", "err")
        return redirect("/?modo=registro")
    uid = nuevo_id("Usuario")
    x("CREATE (:Usuario {id: $id, nombre: $n, email: $e, clave: $c, titular: $t, ciudad: $ci})",
      {"id": uid, "n": f["nombre"].strip()[:80], "e": email, "c": generate_password_hash(f["clave"]), "t": f.get("titular", "").strip()[:120], "ci": f.get("ciudad", "").strip()[:60]})
    session["uid"] = uid
    flash("Cuenta creada. Agrega tus habilidades para recibir recomendaciones.", "ok")
    return redirect("/usuario/%d" % uid)

@app.route("/salir")
def salir():
    session.clear()
    return redirect("/")

# ---------- páginas ----------
@app.route("/inicio")
@login
def inicio():
    u = session["uid"]
    stats = q1("""MATCH (u:Usuario {id: $u})
                  RETURN size([(u)-[:CONECTA_CON]-(c) | c]) AS contactos,
                         size([(u)-[:TIENE_HABILIDAD]->(h) | h]) AS habilidades,
                         size([(u)-[:POSTULA_A]->(o) | o]) AS postulaciones""", {"u": u})
    return render_template("inicio.html", stats=stats, sugeridos=q(S["sugeridos"], {"u": u}), empleos=empleos(u)[:3])

@app.route("/usuario/<int:id>")
@login
def usuario(id):
    p = q1("MATCH (p:Usuario {id: $id}) RETURN p.id AS id, p.nombre AS nombre, p.titular AS titular, p.ciudad AS ciudad, p.bio AS bio", {"id": id})
    if not p:
        return redirect("/inicio")
    u = session["uid"]
    return render_template("perfil.html", p=p, es_yo=(id == u),
        habs=q("MATCH (:Usuario {id: $id})-[:TIENE_HABILIDAD]->(h) RETURN h.id AS id, h.nombre AS nombre ORDER BY h.nombre", {"id": id}),
        trabajos=q("MATCH (:Usuario {id: $id})-[t:TRABAJA_EN]->(e) RETURN e.id AS id, e.nombre AS nombre, t.cargo AS cargo", {"id": id}),
        proys=q("MATCH (:Usuario {id: $id})-[:PARTICIPA_EN]->(p) RETURN p.id AS id, p.nombre AS nombre", {"id": id}),
        n_con=q1("MATCH (:Usuario {id: $id})-[:CONECTA_CON]-(c) RETURN count(c) AS n", {"id": id})["n"],
        es_con=q1("MATCH (:Usuario {id: $u})-[:CONECTA_CON]-(:Usuario {id: $id}) RETURN count(*) AS n", {"u": u, "id": id})["n"] > 0,
        comunes=q(S["comunes"], {"u": u, "o": id}) if id != u else [],
        empresas=q("MATCH (e:Empresa) RETURN e.id AS id, e.nombre AS nombre ORDER BY e.nombre"),
        todas=q("MATCH (h:Habilidad) RETURN h.nombre AS nombre ORDER BY h.nombre"))

@app.route("/red")
@login
def red():
    u, a = session["uid"], request.args
    buscar, otro, destino = a.get("buscar", "").strip(), a.get("otro", type=int), a.get("destino")
    ruta = None
    if destino:
        t, i = destino.split(":")
        ruta = camino(u, t, int(i))
    contactos = q("MATCH (:Usuario {id: $u})-[:CONECTA_CON]-(p) RETURN p.id AS id, p.nombre AS nombre, p.titular AS titular", {"u": u})
    similares = q(S["similares"], {"u": u})
    for s in similares:
        s["hab"] = ", ".join(s["hab"])
    return render_template("red.html", contactos=contactos, similares=similares,
        resultados=q("""MATCH (p:Usuario) WHERE p.id <> $u AND (toLower(p.nombre) CONTAINS toLower($b)
                        OR toLower(coalesce(p.titular, '')) CONTAINS toLower($b))
                        RETURN p.id AS id, p.nombre AS nombre, p.titular AS titular LIMIT 10""", {"u": u, "b": buscar}) if buscar else None,
        buscar=buscar, ids_con={c["id"] for c in contactos},
        otro=otro, comunes=q(S["comunes"], {"u": u, "o": otro}) if otro else None,
        destino=destino, ruta=ruta,
        personas=q("MATCH (p:Usuario) WHERE p.id <> $u RETURN p.id AS id, p.nombre AS nombre ORDER BY p.nombre", {"u": u}),
        empresas=q("MATCH (e:Empresa) RETURN e.id AS id, e.nombre AS nombre ORDER BY e.nombre"))

@app.route("/empleos")
@login
def pagina_empleos():
    return render_template("empleos.html", ofertas=empleos(session["uid"]),
        empresas=q("MATCH (e:Empresa) RETURN e.id AS id, e.nombre AS nombre ORDER BY e.nombre"),
        habs=q("MATCH (h:Habilidad) RETURN h.id AS id, h.nombre AS nombre ORDER BY h.nombre"))

@app.route("/proyectos")
@login
def proyectos():
    ps = q("""MATCH (p:Proyecto)
              RETURN p.id AS id, p.nombre AS nombre, p.descripcion AS descripcion,
                     size([(p)<-[:PARTICIPA_EN]-(u) | u]) AS miembros,
                     size([(p)<-[:PARTICIPA_EN]-(:Usuario {id: $u}) | 1]) AS soy
              ORDER BY p.id""", {"u": session["uid"]})
    for p in ps:
        p["tec"] = q("MATCH (:Proyecto {id: $p})-[:USA_TECNOLOGIA]->(h) RETURN h.nombre AS nombre", {"p": p["id"]})
        p["rel"] = q(S["proyectos_rel"], {"p": p["id"]})
        p["colab"] = q(S["colaboradores"], {"p": p["id"]})
    return render_template("proyectos.html", ps=ps, habs=q("MATCH (h:Habilidad) RETURN h.id AS id, h.nombre AS nombre ORDER BY h.nombre"))

@app.route("/analitica")
@login
def analitica():
    c = lambda etiqueta: q1(f"MATCH (n:{etiqueta}) RETURN count(n) AS c")["c"]
    tot = {"usuarios": c("Usuario"), "conexiones": q1("MATCH ()-[r:CONECTA_CON]->() RETURN count(r) AS c")["c"],
           "empresas": c("Empresa"), "ofertas": c("Oferta")}
    return render_template("analitica.html", infl=q(S["influyentes"]), demanda=q(S["demanda"]), comu=comunidades(), tot=tot)

@app.route("/grafo")
@login
def pagina_grafo():
    return render_template("grafo.html")

@app.route("/api/grafo")
@login
def api_grafo():
    nodos = q("""MATCH (n) WHERE n:Usuario OR n:Empresa OR n:Habilidad OR n:Proyecto OR n:Oferta
                 RETURN labels(n)[0] AS tipo, n.id AS id, coalesce(n.nombre, n.titulo) AS nombre,
                        coalesce(n.titular, n.sector) AS detalle""")
    aristas = q("MATCH (a)-[r]->(b) RETURN labels(a)[0] AS ta, a.id AS ia, type(r) AS rel, labels(b)[0] AS tb, b.id AS ib")
    return jsonify(nodos=nodos, aristas=aristas, yo=session["uid"])

# ---------- acciones (CRUD y relaciones) ----------
@app.post("/perfil/editar")
@login
def editar():
    f = request.form
    x("MATCH (u:Usuario {id: $id}) SET u.nombre = $n, u.titular = $t, u.ciudad = $c, u.bio = $b",
      {"id": session["uid"], "n": f["nombre"].strip()[:80] or "Sin nombre", "t": f.get("titular", "").strip()[:120], "c": f.get("ciudad", "").strip()[:60], "b": f.get("bio", "").strip()[:500]})
    return volver("Perfil actualizado.")

@app.post("/perfil/eliminar")
@login
def eliminar():
    x("MATCH (u:Usuario {id: $id}) DETACH DELETE u", {"id": session["uid"]})   # borra el nodo y todas sus aristas
    session.clear()
    flash("Tu cuenta fue eliminada.", "ok")
    return redirect("/")

@app.post("/conectar/<int:id>")
@login
def conectar(id):
    if id != session["uid"]:
        x("MATCH (a:Usuario {id: $a}), (b:Usuario {id: $b}) MERGE (a)-[:CONECTA_CON]-(b)", {"a": session["uid"], "b": id})
    return volver("Ahora están conectados.")

@app.post("/desconectar/<int:id>")
@login
def desconectar(id):
    x("MATCH (:Usuario {id: $a})-[r:CONECTA_CON]-(:Usuario {id: $b}) DELETE r", {"a": session["uid"], "b": id})
    return volver("Conexión eliminada.")

@app.post("/habilidad/agregar")
@login
def hab_agregar():
    n = request.form["nombre"].strip()[:40]
    if n:
        h = q1("MATCH (h:Habilidad) WHERE toLower(h.nombre) = toLower($n) RETURN h.id AS id", {"n": n})
        hid = h["id"] if h else nuevo_id("Habilidad")
        if not h:
            x("CREATE (:Habilidad {id: $id, nombre: $n})", {"id": hid, "n": n})
        x("MATCH (u:Usuario {id: $u}), (h:Habilidad {id: $h}) MERGE (u)-[:TIENE_HABILIDAD]->(h)", {"u": session["uid"], "h": hid})
    return volver("Habilidad agregada.")

@app.post("/habilidad/quitar/<int:id>")
@login
def hab_quitar(id):
    x("MATCH (:Usuario {id: $u})-[r:TIENE_HABILIDAD]->(:Habilidad {id: $h}) DELETE r", {"u": session["uid"], "h": id})
    return volver()

@app.post("/trabajo/agregar")
@login
def trabajo_agregar():
    f = request.form
    x("MATCH (u:Usuario {id: $u}), (e:Empresa {id: $e}) MERGE (u)-[t:TRABAJA_EN]->(e) SET t.cargo = $c",
      {"u": session["uid"], "e": int(f["empresa_id"]), "c": f.get("cargo")})
    return volver("Experiencia agregada.")

@app.post("/trabajo/quitar/<int:id>")
@login
def trabajo_quitar(id):
    x("MATCH (:Usuario {id: $u})-[r:TRABAJA_EN]->(:Empresa {id: $e}) DELETE r", {"u": session["uid"], "e": id})
    return volver()

@app.post("/proyecto/crear")
@login
def proyecto_crear():
    f = request.form
    x("""MATCH (u:Usuario {id: $u})
         CREATE (p:Proyecto {id: $id, nombre: $n, descripcion: $d})
         CREATE (u)-[:PARTICIPA_EN]->(p)
         WITH p UNWIND $hs AS hid
         MATCH (h:Habilidad {id: hid}) MERGE (p)-[:USA_TECNOLOGIA]->(h)""",
      {"u": session["uid"], "id": nuevo_id("Proyecto"), "n": f["nombre"], "d": f.get("descripcion"), "hs": [int(h) for h in f.getlist("hab")]})
    return volver("Proyecto creado.")

@app.post("/proyecto/unirse/<int:id>")
@login
def proyecto_unirse(id):
    x("MATCH (u:Usuario {id: $u}), (p:Proyecto {id: $p}) MERGE (u)-[:PARTICIPA_EN]->(p)", {"u": session["uid"], "p": id})
    return volver("Te uniste al proyecto.")

@app.post("/oferta/crear")
@login
def oferta_crear():
    f = request.form
    eid = int(f["empresa_id"]) if f.get("empresa_id") else None
    if f.get("empresa_nueva", "").strip():
        eid = nuevo_id("Empresa")
        x("CREATE (:Empresa {id: $id, nombre: $n, sector: $s, ciudad: $c})",
          {"id": eid, "n": f["empresa_nueva"].strip(), "s": f.get("sector"), "c": f.get("ciudad_emp")})
    if not eid:
        return volver("Elige una empresa o escribe el nombre de una nueva.", "err")
    x("""MATCH (e:Empresa {id: $e})
         CREATE (o:Oferta {id: $id, titulo: $t, descripcion: $d})
         CREATE (e)-[:PUBLICA]->(o)
         WITH o UNWIND $hs AS hid
         MATCH (h:Habilidad {id: hid}) MERGE (o)-[:REQUIERE]->(h)""",
      {"e": eid, "id": nuevo_id("Oferta"), "t": f["titulo"], "d": f.get("descripcion"), "hs": [int(h) for h in f.getlist("hab")]})
    return volver("Oferta publicada.")

@app.post("/postular/<int:id>")
@login
def postular(id):
    x("MATCH (u:Usuario {id: $u}), (o:Oferta {id: $o}) MERGE (u)-[:POSTULA_A]->(o)", {"u": session["uid"], "o": id})
    return volver("Postulación enviada.")

if __name__ == "__main__":
    app.run(debug=True)
