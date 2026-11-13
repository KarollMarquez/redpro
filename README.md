# RedPro

Red profesional construida con Flask y Neo4j. El frontend se sirve desde Flask
mediante plantillas HTML y Tailwind CSS.

Incluye feed de publicaciones, perfiles profesionales y de empresa, ofertas con
detalle, postulaciones, proyectos, recomendaciones y exploración visual del grafo.

## Ejecución local

Instala las dependencias:

```powershell
pip install -r requirements.txt
```

Configura las variables de conexión:

```powershell
$env:NEO4J_URI="bolt://localhost:7687"
$env:NEO4J_USER="neo4j"
$env:NEO4J_PASS="TU_CONTRASEÑA_LOCAL"
$env:SECRET_KEY="CLAVE_DE_DESARROLLO"
```

Carga los datos de ejemplo una sola vez:

```powershell
python init_db.py
```

El script también carga publicaciones de ejemplo para el feed. Si cambias
`seed.cypher`, vuelve a ejecutarlo contra una base de datos de desarrollo o
acepta que se eliminarán y recrearán los datos de la aplicación.

Inicia Flask:

```powershell
python app.py
```

## Despliegue en Railway

1. Crea una instancia en Neo4j AuraDB.
2. Ejecuta `init_db.py` una sola vez apuntando a AuraDB. Este script elimina
   y vuelve a crear los nodos de la aplicación.
3. En Railway selecciona **Deploy from GitHub Repo** y elige este repositorio.
4. Configura estas variables en Railway:

```text
NEO4J_URI=neo4j+s://TU_INSTANCIA.databases.neo4j.io
NEO4J_USER=neo4j
NEO4J_PASS=TU_CONTRASEÑA_DE_AURA
SECRET_KEY=TU_CLAVE_ALEATORIA
```

Railway utiliza el comando definido en `Procfile`:

```text
gunicorn app:app
```

No ejecutes `init_db.py` como comando de inicio, porque borraría los datos en
cada reinicio o despliegue.

## Generar `SECRET_KEY`

`SECRET_KEY` no viene de Neo4j. Es una clave independiente que Flask usa para
firmar las sesiones. Genérala localmente con:

```powershell
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

Copia el resultado en Railway como valor de `SECRET_KEY`. No la guardes en el
código ni la subas a GitHub.
