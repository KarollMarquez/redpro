// ===== MODELO DE GRAFO EN NEO4J =====
// Nodos: (:Usuario) (:Empresa) (:Habilidad) (:Proyecto) (:Oferta)
// Relaciones: CONECTA_CON, TRABAJA_EN, TIENE_HABILIDAD, PARTICIPA_EN, PUBLICA, REQUIERE, POSTULA_A, USA_TECNOLOGIA
CREATE CONSTRAINT usuario_id IF NOT EXISTS FOR (n:Usuario) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT usuario_email IF NOT EXISTS FOR (n:Usuario) REQUIRE n.email IS UNIQUE;
CREATE CONSTRAINT empresa_id IF NOT EXISTS FOR (n:Empresa) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT habilidad_id IF NOT EXISTS FOR (n:Habilidad) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT proyecto_id IF NOT EXISTS FOR (n:Proyecto) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT oferta_id IF NOT EXISTS FOR (n:Oferta) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT publicacion_id IF NOT EXISTS FOR (n:Publicacion) REQUIRE n.id IS UNIQUE;

// ---- NODOS ----
UNWIND [
 [1,'Valentina Ruiz','valentina@demo.com','Estudiante de Ingeniería de Sistemas','Barranquilla'],
 [2,'Carlos Mejía','carlos@demo.com','Desarrollador Backend','Barranquilla'],
 [3,'Laura Pérez','laura@demo.com','Diseñadora Web','Cartagena'],
 [4,'Andrés Gómez','andres@demo.com','Analista de Datos','Bogotá'],
 [5,'Sofía Castro','sofia@demo.com','Científica de Datos','Medellín'],
 [6,'Miguel Torres','miguel@demo.com','Ingeniero de Redes','Barranquilla'],
 [7,'Daniela Vega','daniela@demo.com','Administradora de Infraestructura','Cali'],
 [8,'Juan Rojas','juan@demo.com','Técnico en Telecomunicaciones','Santa Marta'],
 [9,'Camila Díaz','camila@demo.com','Desarrolladora Frontend','Medellín'],
 [10,'Felipe Mora','felipe@demo.com','Desarrollador Full Stack','Bogotá'],
 [11,'Isabella León','isabella@demo.com','Ingeniera de Software Java','Cali'],
 [12,'Sebastián Paz','sebastian@demo.com','Ingeniero DevOps','Bogotá']
] AS r
CREATE (:Usuario {id:r[0], nombre:r[1], email:r[2], titular:r[3], ciudad:r[4], clave:$clave});

UNWIND [[1,'TechCaribe','Software','Barranquilla'],[2,'DataNorte','Analítica de datos','Bogotá'],[3,'Redes del Atlántico','Telecomunicaciones','Barranquilla'],[4,'WebStudio','Diseño web','Medellín'],[5,'Nube Andina','Computación en la nube','Bogotá']] AS r
CREATE (:Empresa {id:r[0], nombre:r[1], sector:r[2], ciudad:r[3]});

UNWIND [[1,'Python'],[2,'JavaScript'],[3,'SQL'],[4,'Java'],[5,'Redes'],[6,'HTML/CSS'],[7,'C++'],[8,'Docker'],[9,'Machine Learning'],[10,'Linux']] AS r
CREATE (:Habilidad {id:r[0], nombre:r[1]});

UNWIND [[1,'Sistema de Inventario','Control de stock para pymes'],[2,'Monitor de Red','Panel para vigilar equipos de red'],[3,'Portal Web de Empleo','Bolsa de trabajo regional'],[4,'Modelo Predictivo','Predicción de ventas con datos históricos']] AS r
CREATE (:Proyecto {id:r[0], nombre:r[1], descripcion:r[2]});

UNWIND [[1,'Desarrollador Backend Python','Construir APIs y servicios',1],[2,'Analista de Datos Junior','Reportes y modelos básicos',2],[3,'Ingeniero de Redes','Soporte y configuración de redes',3],[4,'Desarrollador Frontend','Interfaces web responsivas',4],[5,'Desarrollador Java','Microservicios en la nube',5],[6,'Ingeniero DevOps','Automatización y contenedores',5]] AS r
MATCH (e:Empresa {id:r[3]})
CREATE (o:Oferta {id:r[0], titulo:r[1], descripcion:r[2]})
CREATE (e)-[:PUBLICA]->(o);

// ---- RELACIONES ----
UNWIND [[1,2],[1,3],[2,3],[2,4],[3,4],[5,6],[5,7],[6,7],[6,8],[9,10],[9,11],[10,11],[10,12]] AS r
MATCH (a:Usuario {id:r[0]}), (b:Usuario {id:r[1]}) CREATE (a)-[:CONECTA_CON]->(b);

UNWIND [[2,1,'Desarrollador'],[3,1,'Diseñadora'],[4,2,'Analista'],[5,2,'Científica de datos'],[6,3,'Ingeniero'],[7,3,'Administradora'],[8,3,'Técnico'],[9,4,'Frontend'],[10,4,'Full Stack'],[11,5,'Desarrolladora'],[12,5,'DevOps']] AS r
MATCH (u:Usuario {id:r[0]}), (e:Empresa {id:r[1]}) CREATE (u)-[:TRABAJA_EN {cargo:r[2]}]->(e);

UNWIND [[1,1],[1,3],[1,6],[1,5],[2,1],[2,3],[2,9],[3,2],[3,6],[4,1],[4,3],[4,8],[5,1],[5,9],[5,3],[6,5],[6,10],[7,5],[7,8],[7,10],[8,5],[8,7],[9,2],[9,6],[10,2],[10,6],[10,4],[11,4],[11,3],[12,4],[12,8]] AS r
MATCH (u:Usuario {id:r[0]}), (h:Habilidad {id:r[1]}) CREATE (u)-[:TIENE_HABILIDAD]->(h);

UNWIND [[1,1],[2,1],[3,1],[6,2],[7,2],[8,2],[3,3],[9,3],[10,3],[4,4],[5,4],[2,4]] AS r
MATCH (u:Usuario {id:r[0]}), (p:Proyecto {id:r[1]}) CREATE (u)-[:PARTICIPA_EN]->(p);

UNWIND [[1,1],[1,3],[2,5],[2,10],[3,2],[3,6],[4,1],[4,9]] AS r
MATCH (p:Proyecto {id:r[0]}), (h:Habilidad {id:r[1]}) CREATE (p)-[:USA_TECNOLOGIA]->(h);

UNWIND [[1,1],[1,3],[2,1],[2,3],[2,9],[3,5],[3,10],[4,2],[4,6],[5,4],[5,8],[6,8],[6,10],[6,5]] AS r
MATCH (o:Oferta {id:r[0]}), (h:Habilidad {id:r[1]}) CREATE (o)-[:REQUIERE]->(h);

UNWIND [[4,2],[5,2],[6,3]] AS r
MATCH (u:Usuario {id:r[0]}), (o:Oferta {id:r[1]}) CREATE (u)-[:POSTULA_A]->(o);

// ---- PUBLICACIONES DEL FEED ----
UNWIND [
 [1,1,'Estoy construyendo nuevas conexiones y aprendiendo cada día sobre desarrollo de productos. ¿Qué proyecto te tiene motivado esta semana?','2026-01-15T10:00:00Z'],
 [2,2,'Terminamos una primera versión de nuestra API para inventarios. Buscamos personas interesadas en backend y datos para probarla.','2026-01-14T16:30:00Z'],
 [5,3,'Compartir conocimiento abre puertas. Esta semana estoy explorando Machine Learning aplicado a problemas reales de negocios.','2026-01-13T12:15:00Z'],
 [9,4,'¿Alguien está trabajando en proyectos de frontend accesibles? Me encantaría conocer experiencias y buenas prácticas.','2026-01-12T09:45:00Z']
] AS r
MATCH (u:Usuario {id:r[0]})
CREATE (p:Publicacion {id:r[1], texto:r[2], fecha:r[3]})
CREATE (u)-[:PUBLICA_POST]->(p);
