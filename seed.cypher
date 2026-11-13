// RedPro - datos de demostracion para una red profesional colombiana
// Las credenciales de los usuarios demo se generan en init_db.py.

CREATE CONSTRAINT usuario_id IF NOT EXISTS FOR (n:Usuario) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT usuario_email IF NOT EXISTS FOR (n:Usuario) REQUIRE n.email IS UNIQUE;
CREATE CONSTRAINT empresa_id IF NOT EXISTS FOR (n:Empresa) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT habilidad_id IF NOT EXISTS FOR (n:Habilidad) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT proyecto_id IF NOT EXISTS FOR (n:Proyecto) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT oferta_id IF NOT EXISTS FOR (n:Oferta) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT publicacion_id IF NOT EXISTS FOR (n:Publicacion) REQUIRE n.id IS UNIQUE;
CREATE CONSTRAINT comunidad_id IF NOT EXISTS FOR (n:Comunidad) REQUIRE n.id IS UNIQUE;

// Usuarios: id, nombre, correo, titular, ciudad, bio, anos de experiencia
UNWIND [
 [1,'Valentina Ruiz','valentina@demo.com','Estudiante de Ingenieria de Sistemas','Barranquilla','Estudiante de sistemas enfocada en construir productos digitales con impacto local. Me interesa conectar datos, personas y oportunidades.',1],
 [2,'Carlos Mejia','carlos@demo.com','Backend Engineer','Barranquilla','Ingeniero backend que disfruta convertir procesos complejos en APIs simples, observables y faciles de mantener.',5],
 [3,'Laura Perez','laura@demo.com','Product Designer','Cartagena','Diseñadora de producto enfocada en experiencias claras para servicios financieros y plataformas educativas.',4],
 [4,'Andres Gomez','andres@demo.com','Data Analyst','Bogota','Analista de datos con experiencia en tableros ejecutivos, experimentacion y toma de decisiones basada en evidencia.',4],
 [5,'Sofia Castro','sofia@demo.com','Data Scientist','Medellin','Cientifica de datos interesada en modelos responsables, forecasting y soluciones de analitica para equipos de negocio.',6],
 [6,'Miguel Torres','miguel@demo.com','Network Engineer','Barranquilla','Ingeniero de redes especializado en infraestructura critica, automatizacion y seguridad para operaciones distribuidas.',7],
 [7,'Daniela Vega','daniela@demo.com','Cloud Infrastructure Engineer','Cali','Trabajo en plataformas cloud confiables y en automatizar el camino entre una idea y un servicio en produccion.',6],
 [8,'Juan Rojas','juan@demo.com','Telecommunications Technician','Santa Marta','Tecnico en telecomunicaciones con experiencia en despliegues de conectividad y soporte en campo.',5],
 [9,'Camila Diaz','camila@demo.com','Frontend Developer','Medellin','Desarrolladora frontend con obsesion por los detalles, la accesibilidad y las interfaces que se sienten naturales.',4],
 [10,'Felipe Mora','felipe@demo.com','Full Stack Developer','Bogota','Construyo productos web de punta a punta y ayudo a equipos pequeños a lanzar con foco y velocidad.',7],
 [11,'Isabella Leon','isabella@demo.com','Java Software Engineer','Cali','Ingeniera de software orientada a servicios Java, integraciones y calidad automatizada en entornos de alto volumen.',8],
 [12,'Sebastian Paz','sebastian@demo.com','DevOps Engineer','Bogota','DevOps con experiencia en CI/CD, observabilidad y plataformas que permiten a los equipos entregar mejor.',7],
 [13,'Mariana Ospina','maria.ospina@demo.com','UX Researcher','Medellin','Investigo necesidades reales para convertirlas en productos utiles. Me mueven la escucha, la evidencia y el trabajo colaborativo.',5],
 [14,'Nicolas Herrera','nicolas.herrera@demo.com','Mobile Developer','Bogota','Desarrollador mobile enfocado en Android, rendimiento y experiencias consistentes incluso con conectividad limitada.',5],
 [15,'Juliana Pardo','juliana.pardo@demo.com','Product Manager','Barranquilla','Product manager con experiencia conectando estrategia, discovery y entrega para equipos de tecnologia.',6],
 [16,'Mateo Salazar','mateo.salazar@demo.com','Security Engineer','Bogota','Ayudo a equipos a encontrar riesgos temprano y a construir controles de seguridad que no bloqueen el negocio.',8],
 [17,'Paula Mendoza','paula.mendoza@demo.com','QA Automation Engineer','Medellin','Especialista en calidad y automatizacion. Me gusta hacer visibles los riesgos antes de que lleguen a los usuarios.',5],
 [18,'Tomas Nieto','tomas.nieto@demo.com','Solutions Architect','Bogota','Arquitecto de soluciones con experiencia diseñando integraciones escalables para banca, retail y sector publico.',10],
 [19,'Sara Cardenas','sara.cardenas@demo.com','Content Strategist','Cartagena','Creo contenidos que explican lo complejo con claridad y construyen comunidades alrededor de productos digitales.',4],
 [20,'Diego Restrepo','diego.restrepo@demo.com','React Developer','Medellin','Frontend developer enfocado en sistemas de diseño, performance y colaboracion estrecha con producto y diseño.',6],
 [21,'Ana Maria Silva','ana.silva@demo.com','People Operations Lead','Barranquilla','Construyo culturas de trabajo sanas y procesos de talento que ayudan a crecer sin perder el sentido humano.',7],
 [22,'Jorge Marin','jorge.marin@demo.com','Database Engineer','Bogota','Ingeniero de datos y bases de datos interesado en rendimiento, modelado y plataformas de informacion confiables.',9],
 [23,'Natalia Fuentes','natalia.fuentes@demo.com','Machine Learning Engineer','Medellin','Llevo modelos de machine learning desde el notebook hasta servicios medibles y mantenibles en produccion.',5],
 [24,'Ricardo Bernal','ricardo.bernal@demo.com','SRE','Bogota','SRE enfocado en confiabilidad, capacidad y respuesta a incidentes para productos que no pueden detenerse.',8],
 [25,'Maria Jose Rios','maria.rios@demo.com','Visual Designer','Cartagena','Diseñadora visual que convierte identidad de marca en experiencias digitales memorables y coherentes.',5],
 [26,'Alejandro Gil','alejandro.gil@demo.com','Python Developer','Barranquilla','Desarrollador Python con experiencia en automatizacion, integraciones y herramientas internas para operaciones.',4],
 [27,'Gabriela Soto','gabriela.soto@demo.com','Business Analyst','Cali','Analista de negocio que traduce problemas operativos en decisiones, procesos y productos accionables.',6],
 [28,'Martin Acosta','martin.acosta@demo.com','iOS Developer','Bogota','Desarrollador iOS apasionado por las experiencias nativas, el rendimiento y la calidad de las interacciones.',6],
 [29,'Luisa Fernanda Mora','luisa.mora@demo.com','Community Manager','Medellin','Construyo conversaciones alrededor de marcas y productos con una mezcla de estrategia, creatividad y datos.',4],
 [30,'Emilio Vargas','emilio.vargas@demo.com','Platform Engineer','Bogota','Diseño plataformas internas que reducen friccion para los equipos y hacen visible el camino a produccion.',7],
 [31,'Carolina Nieto','carolina.nieto@demo.com','Research Data Analyst','Barranquilla','Analista que combina investigacion social, datos y visualizacion para encontrar historias que orienten decisiones.',3],
 [32,'Samuel Correa','samuel.correa@demo.com','Support Engineer','Cali','Ingeniero de soporte tecnico con enfoque en diagnostico, documentacion y experiencias de cliente confiables.',5],
 [33,'Manuela Rios','manuela.rios@demo.com','Product Marketing Manager','Medellin','Conecto producto, mercado y narrativa para que las buenas soluciones encuentren a las personas correctas.',7],
 [34,'David Londoño','david.londono@demo.com','Cloud Data Engineer','Bogota','Construyo pipelines y plataformas de datos que permiten responder preguntas de negocio con confianza.',6],
 [35,'Elena Ruiz','elena.ruiz@demo.com','Agile Coach','Cartagena','Acompaño equipos a trabajar con foco, conversaciones honestas y ciclos de aprendizaje continuos.',9],
 [36,'Oscar Mendez','oscar.mendez@demo.com','Embedded Systems Engineer','Barranquilla','Ingeniero de sistemas embebidos con experiencia en sensores, telemetria y soluciones para industria.',8],
 [37,'Valeria Leon','valeria.leon@demo.com','Data Visualization Specialist','Cali','Diseño visualizaciones que ayudan a entender tendencias y tomar mejores decisiones.',4],
 [38,'Cristian Parra','cristian.parra@demo.com','Technical Product Manager','Bogota','Lidero productos tecnicos alineando arquitectura, necesidades de clientes y resultados medibles.',8],
 [39,'Rocio Acosta','rocio.acosta@demo.com','Recruiting Partner','Medellin','Conecto talento especializado con equipos donde pueda crecer y aportar desde el primer dia.',6],
 [40,'Hugo Beltran','hugo.beltran@demo.com','Data Platform Lead','Bogota','Lidero plataformas de datos y equipos que convierten informacion dispersa en capacidades de negocio.',12]
] AS r
CREATE (:Usuario {id:r[0], nombre:r[1], email:r[2], titular:r[3], ciudad:r[4], bio:r[5], experiencia:r[6], clave:$clave});

// Empresas: id, nombre, sector, tamaño, ciudad, descripcion
UNWIND [
 [1,'TechCaribe','Software B2B','51-200','Barranquilla','Construimos herramientas digitales para que las empresas del Caribe operen mejor.'],
 [2,'DataNorte','Analitica y datos','11-50','Bogota','Ayudamos a equipos de negocio a tomar decisiones con datos confiables y accionables.'],
 [3,'Redes del Atlantico','Telecomunicaciones','201-500','Barranquilla','Conectamos comunidades y empresas con infraestructura de comunicaciones resiliente.'],
 [4,'WebStudio','Diseño y tecnologia','11-50','Medellin','Estudio digital que crea productos web accesibles, utiles y faciles de usar.'],
 [5,'Nube Andina','Cloud computing','51-200','Bogota','Plataforma cloud regional para equipos que necesitan escalar sin perder control.'],
 [6,'SaludConecta','Healthtech','51-200','Medellin','Tecnologia para acercar servicios de salud a pacientes y profesionales.'],
 [7,'CaribePay','Fintech','201-500','Barranquilla','Infraestructura de pagos para comercios que quieren crecer en Colombia.'],
 [8,'RutaVerde','Logistica sostenible','11-50','Bogota','Optimizamos entregas urbanas con datos, tecnologia y una mirada sostenible.'],
 [9,'AulaAbierta','Edtech','51-200','Medellin','Creamos experiencias de aprendizaje accesibles para toda Colombia.'],
 [10,'Cosecha Digital','Agtech','11-50','Barranquilla','Conectamos productores con informacion para mejorar sus decisiones y su productividad.'],
 [11,'MercadoLocal','Comercio digital','51-200','Cartagena','Herramientas para que negocios regionales vendan mejor y conozcan a sus clientes.'],
 [12,'Civica Labs','Govtech','11-50','Bogota','Diseñamos servicios digitales simples para instituciones y ciudadanos.'],
 [13,'Orbita Mobile','Tecnologia movil','51-200','Medellin','Experiencias mobile para marcas que quieren estar cerca de sus usuarios.'],
 [14,'SeguraTech','Ciberseguridad','51-200','Bogota','Protegemos productos y datos con seguridad practica, medible y humana.'],
 [15,'Marea Creativa','Marca y contenido','11-50','Cartagena','Estrategia, diseño y contenido para marcas que quieren contar mejores historias.']
] AS r
CREATE (:Empresa {id:r[0], nombre:r[1], sector:r[2], tamano:r[3], ciudad:r[4], descripcion:r[5]});

UNWIND [
 [1,'Python'],[2,'JavaScript'],[3,'SQL'],[4,'Java'],[5,'Redes'],[6,'HTML y CSS'],
 [7,'C++'],[8,'Docker'],[9,'Machine Learning'],[10,'Linux'],[11,'React'],
 [12,'AWS'],[13,'Figma'],[14,'Product Management'],[15,'Data Visualization'],
 [16,'Kubernetes'],[17,'Testing'],[18,'Ciberseguridad'],[19,'Swift'],[20,'Power BI']
] AS r
CREATE (:Habilidad {id:r[0], nombre:r[1]});

UNWIND [
 [1,'Sistema de Inventario','Plataforma para que pymes controlen stock, compras y alertas de reposicion.','En produccion'],
 [2,'Monitor de Red','Panel de observabilidad para vigilar equipos y anticipar incidentes de conectividad.','Beta'],
 [3,'Portal Web de Empleo','Bolsa de trabajo regional basada en conexiones, habilidades y proyectos.','En desarrollo'],
 [4,'Modelo Predictivo de Ventas','Modelos para anticipar demanda y ayudar a equipos comerciales a planear inventario.','Piloto'],
 [5,'Historias del Caribe','Repositorio digital de relatos, fotografias y memoria de comunidades costeras.','En investigacion'],
 [6,'Ruta de Ultima Milla','Optimizacion de entregas urbanas para reducir tiempos, costos y emisiones.','Beta'],
 [7,'Aula Rural','Contenido educativo offline para estudiantes con conectividad intermitente.','En desarrollo'],
 [8,'Pagos para Emprendedores','Flujo de cobros y conciliacion para negocios que venden por canales digitales.','En produccion'],
 [9,'Panel de Salud Comunitaria','Visualizacion de indicadores de atencion para equipos territoriales.','Piloto'],
 [10,'Cosecha Inteligente','Sensores y alertas para apoyar decisiones de riego y fertilizacion.','Prototipo'],
 [11,'Kit de Accesibilidad Web','Componentes y guias para crear experiencias digitales mas inclusivas.','En desarrollo'],
 [12,'Centro de Incidentes','Herramienta para coordinar respuesta, comunicacion y aprendizaje despues de incidentes.','En produccion'],
 [13,'Mapa de Talento','Exploracion de habilidades y conexiones para comunidades profesionales.','Beta'],
 [14,'Mercado de Creadores','Espacio para conectar marcas regionales con creadores de contenido.','En desarrollo'],
 [15,'Laboratorio de Datos Abiertos','Proyecto comunitario para limpiar y visualizar datasets publicos.','En investigacion']
] AS r
CREATE (:Proyecto {id:r[0], nombre:r[1], descripcion:r[2], estado:r[3]});

UNWIND [
 [1,'Backend Engineer Python','Construir APIs para el sistema de inventario, integrar servicios de terceros y mejorar la observabilidad del producto. Trabajaras con producto y frontend en ciclos cortos. Buscamos alguien que disfrute aprender y dejar sistemas mas simples.','Hibrido','$7.000.000 - $9.000.000 COP','Barranquilla','2026-02-15',1],
 [2,'Data Analyst Junior','Convertir preguntas de negocio en analisis claros, tableros y recomendaciones. Acompañaras a equipos comerciales y de operaciones en la lectura de sus indicadores. El rol combina SQL, visualizacion y mucha curiosidad.','Remoto','$4.500.000 - $6.000.000 COP','Bogota','2026-02-20',2],
 [3,'Ingeniero de Redes','Diseñar, operar y documentar infraestructura de conectividad para clientes empresariales. Participaras en proyectos de alta disponibilidad y automatizacion de monitoreo. Se requiere disponibilidad para visitas puntuales.','Presencial','$6.500.000 - $8.500.000 COP','Barranquilla','2026-02-18',3],
 [4,'Product Designer','Liderar discovery, prototipos y decisiones de experiencia para nuevas funcionalidades. Trabajaras junto a producto e ingenieria desde el problema hasta la medicion del resultado.','Hibrido','$6.000.000 - $8.000.000 COP','Medellin','2026-03-01',4],
 [5,'Cloud Platform Engineer','Construir componentes de plataforma para que los equipos desplieguen servicios con seguridad y autonomia. El trabajo incluye infraestructura como codigo, observabilidad y automatizacion.','Remoto','$9.000.000 - $12.000.000 COP','Bogota','2026-02-25',5],
 [6,'Machine Learning Engineer','Llevar modelos de prediccion desde la exploracion hasta servicios confiables en produccion. Trabajaras con datos de ventas, experimentacion y monitoreo de calidad.','Hibrido','$8.000.000 - $11.000.000 COP','Medellin','2026-03-05',6],
 [7,'QA Automation Engineer','Diseñar estrategias de calidad y automatizar pruebas para web y APIs. Ayudaras a que el equipo detecte riesgos temprano y entregue cambios con confianza.','Remoto','$5.500.000 - $7.500.000 COP','Medellin','2026-02-28',7],
 [8,'Full Stack Developer','Desarrollar experiencias web completas para comercios regionales. Participaras en decisiones de arquitectura, experiencia y lanzamiento con un equipo pequeño.','Hibrido','$7.000.000 - $10.000.000 COP','Cartagena','2026-03-08',11],
 [9,'Mobile Developer Android','Crear nuevas experiencias Android con foco en rendimiento, accesibilidad y estabilidad en diferentes dispositivos.','Remoto','$6.500.000 - $9.000.000 COP','Medellin','2026-03-10',13],
 [10,'Security Engineer','Acompañar equipos de producto en threat modeling, controles preventivos y respuesta a hallazgos. Buscamos seguridad practica y cercana al negocio.','Hibrido',' $9.000.000 - $13.000.000 COP','Bogota','2026-02-22',14],
 [11,'Product Manager','Definir oportunidades y prioridades para una plataforma de pagos para emprendedores. Necesitamos alguien que conecte clientes, datos y equipos tecnicos.','Hibrido',' $8.000.000 - $11.000.000 COP','Barranquilla','2026-03-12',7],
 [12,'Content Strategist','Crear la estrategia editorial de una plataforma que cuenta historias del Caribe. Investigaras audiencias, editaras contenidos y mediras su impacto.','Remoto',' $4.500.000 - $6.500.000 COP','Cartagena','2026-03-15',15],
 [13,'Data Engineer','Diseñar pipelines confiables para integrar datos de sensores, ventas y operaciones. Trabajaras con equipos de analitica y producto para habilitar nuevas capacidades.','Hibrido',' $8.000.000 - $11.000.000 COP','Bogota','2026-03-18',8],
 [14,'React Developer','Construir componentes accesibles y consistentes para el sistema de diseño. Participaras en performance, testing y colaboracion diaria con diseño.','Remoto',' $6.000.000 - $8.500.000 COP','Medellin','2026-03-20',9],
 [15,'Business Analyst','Mapear procesos y convertir necesidades de instituciones en historias claras, metricas y soluciones digitales.','Hibrido',' $5.000.000 - $7.000.000 COP','Bogota','2026-03-22',12],
 [16,'iOS Developer','Crear funcionalidades nativas para una experiencia mobile de alto uso. Cuidaras performance, arquitectura y calidad de lanzamiento.','Remoto',' $7.000.000 - $10.000.000 COP','Bogota','2026-03-25',13],
 [17,'SRE','Mejorar confiabilidad, capacidad y respuesta a incidentes de una plataforma de pagos. El rol combina automatizacion y acompañamiento a equipos.','Hibrido',' $10.000.000 - $14.000.000 COP','Bogota','2026-03-27',7],
 [18,'UX Researcher','Planear investigaciones, entrevistar usuarios y convertir hallazgos en decisiones de producto. Trabajaras con equipos de diseño y producto.','Hibrido',' $6.000.000 - $8.000.000 COP','Medellin','2026-04-01',4],
 [19,'Embedded Systems Engineer','Diseñar firmware y telemetria para sensores de agricultura de precision. Necesitamos experiencia integrando hardware, datos y pruebas en campo.','Presencial',' $7.000.000 - $10.000.000 COP','Barranquilla','2026-04-03',10],
 [20,'Community Manager','Construir conversaciones, campañas y contenidos para una comunidad de creadores regionales. Mediras crecimiento, participacion y calidad de las interacciones.','Hibrido',' $4.000.000 - $5.500.000 COP','Cartagena','2026-04-05',15],
 [21,'Technical Product Manager','Liderar el roadmap de una plataforma de datos, alineando arquitectura, usuarios internos y resultados de negocio.','Remoto',' $10.000.000 - $14.000.000 COP','Bogota','2026-04-08',5],
 [22,'Power BI Analyst','Diseñar tableros ejecutivos y modelos semanticos para operaciones y ventas. Debes disfrutar explicar hallazgos y trabajar con usuarios no tecnicos.','Hibrido',' $4.500.000 - $6.500.000 COP','Cali','2026-04-10',2],
 [23,'Support Engineer','Resolver retos tecnicos de clientes, mejorar documentacion y detectar patrones para reducir incidentes repetitivos.','Presencial',' $4.000.000 - $6.000.000 COP','Cali','2026-04-12',6],
 [24,'Agile Coach','Acompañar varios equipos en practicas de entrega, conversaciones de mejora y alineacion con objetivos de producto.','Remoto',' $7.000.000 - $10.000.000 COP','Cartagena','2026-04-15',9],
 [25,'Visual Designer','Crear identidad visual y piezas digitales para marcas con proposito. Trabajaras en campañas, sistemas visuales y narrativas de producto.','Hibrido',' $5.000.000 - $7.000.000 COP','Cartagena','2026-04-18',15]
] AS r
MATCH (e:Empresa {id:r[7]})
CREATE (o:Oferta {id:r[0], titulo:r[1], descripcion:r[2], modalidad:r[3], salario:r[4], ciudad:r[5], fecha:r[6]})
CREATE (e)-[:PUBLICA]->(o);

// Habilidades de usuarios: usuario, habilidad, nivel
UNWIND [
 [1,1,'Intermedio'],[1,2,'Intermedio'],[1,3,'Basico'],[1,6,'Intermedio'],[1,13,'Intermedio'],
 [2,1,'Avanzado'],[2,3,'Avanzado'],[2,8,'Intermedio'],[2,10,'Avanzado'],[2,12,'Intermedio'],
 [3,6,'Avanzado'],[3,13,'Avanzado'],[3,14,'Intermedio'],[3,11,'Intermedio'],
 [4,3,'Avanzado'],[4,15,'Avanzado'],[4,20,'Avanzado'],[4,1,'Intermedio'],
 [5,1,'Avanzado'],[5,3,'Avanzado'],[5,9,'Avanzado'],[5,15,'Avanzado'],[5,12,'Intermedio'],
 [6,5,'Avanzado'],[6,10,'Avanzado'],[6,18,'Intermedio'],[6,8,'Intermedio'],
 [7,8,'Avanzado'],[7,10,'Avanzado'],[7,12,'Avanzado'],[7,16,'Intermedio'],
 [8,5,'Avanzado'],[8,10,'Intermedio'],[8,18,'Intermedio'],
 [9,2,'Avanzado'],[9,6,'Avanzado'],[9,11,'Avanzado'],[9,13,'Intermedio'],[9,17,'Intermedio'],
 [10,1,'Avanzado'],[10,2,'Avanzado'],[10,11,'Avanzado'],[10,3,'Intermedio'],[10,8,'Intermedio'],
 [11,4,'Avanzado'],[11,3,'Intermedio'],[11,17,'Avanzado'],[11,10,'Intermedio'],
 [12,8,'Avanzado'],[12,10,'Avanzado'],[12,12,'Avanzado'],[12,16,'Intermedio'],[12,17,'Intermedio'],
 [13,13,'Avanzado'],[13,14,'Intermedio'],[13,15,'Intermedio'],[13,6,'Intermedio'],
 [14,2,'Avanzado'],[14,19,'Avanzado'],[14,11,'Intermedio'],[14,17,'Intermedio'],
 [15,14,'Avanzado'],[15,3,'Intermedio'],[15,15,'Intermedio'],[15,13,'Intermedio'],
 [16,18,'Avanzado'],[16,10,'Avanzado'],[16,12,'Intermedio'],[16,8,'Intermedio'],
 [17,17,'Avanzado'],[17,2,'Intermedio'],[17,3,'Intermedio'],[17,11,'Intermedio'],
 [18,4,'Avanzado'],[18,12,'Intermedio'],[18,3,'Intermedio'],[18,14,'Avanzado'],
 [19,6,'Intermedio'],[19,13,'Intermedio'],[19,15,'Avanzado'],[19,14,'Intermedio'],
 [20,2,'Avanzado'],[20,11,'Avanzado'],[20,13,'Intermedio'],[20,6,'Intermedio'],
 [21,14,'Avanzado'],[21,15,'Intermedio'],[21,3,'Intermedio'],[21,17,'Intermedio'],
 [22,3,'Avanzado'],[22,20,'Avanzado'],[22,15,'Intermedio'],[22,12,'Intermedio'],
 [23,1,'Avanzado'],[23,9,'Avanzado'],[23,3,'Intermedio'],[23,12,'Intermedio'],
 [24,8,'Avanzado'],[24,16,'Avanzado'],[24,10,'Avanzado'],[24,18,'Intermedio'],
 [25,6,'Avanzado'],[25,13,'Avanzado'],[25,15,'Intermedio'],[25,14,'Intermedio'],
 [26,1,'Avanzado'],[26,2,'Intermedio'],[26,3,'Intermedio'],[26,8,'Intermedio'],
 [27,3,'Avanzado'],[27,14,'Intermedio'],[27,20,'Avanzado'],[27,15,'Intermedio'],
 [28,19,'Avanzado'],[28,2,'Intermedio'],[28,17,'Intermedio'],[28,11,'Intermedio'],
 [29,2,'Avanzado'],[29,15,'Intermedio'],[29,13,'Intermedio'],[29,14,'Intermedio'],
 [30,8,'Avanzado'],[30,12,'Avanzado'],[30,16,'Avanzado'],[30,10,'Avanzado'],
 [31,3,'Avanzado'],[31,15,'Avanzado'],[31,20,'Intermedio'],[31,9,'Intermedio'],
 [32,10,'Avanzado'],[32,17,'Intermedio'],[32,1,'Intermedio'],[32,18,'Basico'],
 [33,14,'Avanzado'],[33,15,'Intermedio'],[33,2,'Intermedio'],[33,13,'Intermedio'],
 [34,1,'Avanzado'],[34,3,'Avanzado'],[34,12,'Avanzado'],[34,16,'Intermedio'],[34,10,'Intermedio'],
 [35,14,'Avanzado'],[35,17,'Intermedio'],[35,15,'Intermedio'],[35,13,'Intermedio'],
 [36,7,'Avanzado'],[36,10,'Avanzado'],[36,5,'Intermedio'],[36,3,'Basico'],
 [37,15,'Avanzado'],[37,20,'Intermedio'],[37,13,'Avanzado'],[37,3,'Intermedio'],
 [38,14,'Avanzado'],[38,3,'Intermedio'],[38,1,'Intermedio'],[38,12,'Intermedio'],
 [39,14,'Avanzado'],[39,15,'Intermedio'],[39,3,'Intermedio'],[39,13,'Intermedio'],
 [40,1,'Avanzado'],[40,3,'Avanzado'],[40,9,'Avanzado'],[40,12,'Avanzado'],[40,15,'Intermedio']
] AS r
MATCH (u:Usuario {id:r[0]}), (h:Habilidad {id:r[1]})
CREATE (u)-[:TIENE_HABILIDAD {nivel:r[2]}]->(h);

// Historial laboral: usuario, empresa, cargo, periodo
UNWIND [
 [2,1,'Backend Engineer','2022-actual'],[3,4,'Product Designer','2021-actual'],[4,2,'Data Analyst','2023-actual'],
 [5,6,'Data Scientist','2020-actual'],[6,3,'Network Engineer','2019-actual'],[7,5,'Cloud Engineer','2020-actual'],
 [8,3,'Tecnico de campo','2021-actual'],[9,4,'Frontend Developer','2022-actual'],[10,1,'Full Stack Developer','2019-actual'],
 [11,5,'Java Engineer','2018-actual'],[12,5,'DevOps Engineer','2019-actual'],[13,4,'UX Researcher','2021-actual'],
 [14,13,'Mobile Developer','2022-actual'],[15,7,'Product Manager','2020-actual'],[16,14,'Security Engineer','2018-actual'],
 [17,7,'QA Engineer','2021-actual'],[18,5,'Solutions Architect','2016-actual'],[19,15,'Content Strategist','2022-actual'],
 [20,4,'React Developer','2020-actual'],[21,1,'People Operations Lead','2019-actual'],[22,2,'Database Engineer','2017-actual'],
 [23,6,'ML Engineer','2021-actual'],[24,5,'SRE','2018-actual'],[25,15,'Visual Designer','2021-actual'],
 [26,1,'Python Developer','2022-actual'],[27,12,'Business Analyst','2020-actual'],[28,13,'iOS Developer','2020-actual'],
 [29,15,'Community Manager','2022-actual'],[30,5,'Platform Engineer','2019-actual'],[31,10,'Data Analyst','2023-actual'],
 [32,6,'Support Engineer','2021-actual'],[33,15,'Product Marketing Manager','2020-actual'],[34,8,'Data Engineer','2020-actual'],
 [35,9,'Agile Coach','2017-actual'],[36,10,'Embedded Engineer','2018-actual'],[37,2,'Data Visualization Specialist','2022-actual'],
 [38,5,'Technical Product Manager','2018-actual'],[39,6,'Recruiting Partner','2020-actual'],[40,2,'Data Platform Lead','2014-actual']
] AS r
MATCH (u:Usuario {id:r[0]}), (e:Empresa {id:r[1]})
CREATE (u)-[:TRABAJA_EN {cargo:r[2], periodo:r[3]}]->(e);

// Conexiones: clusters de tecnologia, datos, producto y Caribe, con puentes
UNWIND [
 [1,2],[1,3],[1,15],[1,26],[1,31],[2,10],[2,22],[2,26],[2,34],[2,40],
 [3,9],[3,13],[3,19],[3,25],[3,29],[3,33],[4,5],[4,22],[4,27],[4,31],
 [5,23],[5,34],[5,37],[5,40],[6,7],[6,8],[6,16],[6,36],[7,12],[7,24],
 [7,30],[8,36],[9,14],[9,20],[9,28],[10,11],[10,18],[10,20],[11,12],[11,17],
 [12,16],[12,24],[13,15],[13,21],[14,20],[14,28],[15,21],[15,33],[16,18],
 [16,24],[17,20],[17,32],[18,22],[18,30],[19,25],[19,29],[20,28],[21,27],
 [22,34],[23,40],[24,30],[25,29],[26,36],[27,31],[30,38],[33,39],[35,38],
 [2,18],[4,15],[5,20],[7,18],[9,22],[12,21],[16,34],[19,37],[24,40]
] AS r
MATCH (a:Usuario {id:r[0]}), (b:Usuario {id:r[1]})
CREATE (a)-[:CONECTA_CON]->(b);

// Proyectos y roles de sus miembros
UNWIND [
 [1,1,'Product Owner'],[1,2,'Backend'],[1,26,'Integraciones'],[2,6,'Lider tecnico'],[2,7,'Infraestructura'],[2,8,'Operaciones'],
 [3,15,'Product Manager'],[3,9,'Frontend'],[3,10,'Full Stack'],[3,39,'Recruiting'],[4,4,'Analitica'],[4,5,'Modelado'],
 [4,23,'Machine Learning'],[4,40,'Data Platform'],[5,19,'Investigacion'],[5,25,'Diseño visual'],[5,29,'Comunidad'],
 [6,18,'Arquitectura'],[6,24,'SRE'],[6,30,'Plataforma'],[7,3,'Experiencia'],[7,13,'Investigacion'],[7,33,'Contenido'],
 [8,11,'Backend'],[8,14,'Mobile'],[8,28,'iOS'],[9,4,'Analitica'],[9,31,'Datos'],[9,37,'Visualizacion'],
 [10,36,'Hardware'],[10,6,'Redes'],[10,8,'Campo'],[11,3,'Diseño'],[11,9,'Frontend'],[11,20,'Componentes'],
 [12,12,'Confiabilidad'],[12,16,'Seguridad'],[12,17,'Calidad'],[13,1,'Investigacion'],[13,15,'Producto'],[13,38,'Estrategia'],
 [14,19,'Contenido'],[14,25,'Visual'],[14,33,'Marketing'],[15,22,'Datos'],[15,27,'Negocio'],[15,37,'Visualizacion']
] AS r
MATCH (p:Proyecto {id:r[0]}), (u:Usuario {id:r[1]})
CREATE (u)-[:PARTICIPA_EN {rol:r[2]}]->(p);

// Tecnologias de proyectos
UNWIND [
 [1,1],[1,3],[1,8],[2,5],[2,10],[2,12],[3,2],[3,6],[3,11],[4,1],[4,3],[4,9],[4,15],
 [5,6],[5,13],[5,15],[6,1],[6,3],[6,12],[6,15],[7,2],[7,6],[7,13],[8,2],[8,3],[8,19],
 [9,3],[9,15],[9,20],[10,7],[10,5],[10,10],[11,2],[11,6],[11,13],[12,8],[12,16],[12,18],
 [13,3],[13,14],[13,15],[14,2],[14,13],[14,15],[15,3],[15,15],[15,20]
] AS r
MATCH (p:Proyecto {id:r[0]}), (h:Habilidad {id:r[1]})
CREATE (p)-[:USA_TECNOLOGIA]->(h);

// Requisitos de ofertas
UNWIND [
 [1,1],[1,3],[1,8],[1,10],[2,3],[2,15],[2,20],[3,5],[3,10],[3,18],[4,6],[4,13],[4,14],
 [5,8],[5,10],[5,12],[5,16],[6,1],[6,3],[6,9],[6,12],[7,3],[7,11],[7,17],[8,2],[8,6],
 [8,11],[9,2],[9,17],[9,19],[10,3],[10,12],[10,18],[11,3],[11,14],[11,15],[12,2],[12,13],
 [12,15],[13,1],[13,3],[13,12],[14,2],[14,6],[14,11],[14,17],[15,3],[15,14],[15,20],
 [16,2],[16,17],[16,19],[17,8],[17,10],[17,12],[17,16],[18,13],[18,14],[18,15],[19,3],
 [19,7],[19,10],[20,2],[20,13],[20,15],[21,3],[21,12],[21,14],[21,16],[22,3],[22,15],
 [22,20],[23,1],[23,3],[23,10],[24,14],[24,17],[24,15],[25,6],[25,13],[25,14]
] AS r
MATCH (o:Oferta {id:r[0]}), (h:Habilidad {id:r[1]})
CREATE (o)-[:REQUIERE]->(h);

UNWIND [[1,1],[2,4],[3,6],[4,1],[5,2],[6,3],[7,9],[8,10],[9,14],[10,16],[11,15],[12,19],[13,23],[14,20],[15,27],[16,28],[17,12],[18,13],[19,36],[20,29],[21,38],[22,31],[23,32],[24,35],[25,25]] AS r
MATCH (u:Usuario {id:r[1]}), (o:Oferta {id:r[0]})
CREATE (u)-[:POSTULA_A]->(o);

// Publicaciones del feed
UNWIND [
 [1,1,'Estoy construyendo nuevas conexiones y aprendiendo cada dia sobre desarrollo de productos. ¿Que proyecto te tiene motivado esta semana?','2026-01-15T10:00:00Z','Pregunta'],
 [2,2,'Terminamos una primera version de nuestra API para inventarios. Buscamos personas interesadas en backend y datos para probarla.','2026-01-14T16:30:00Z','Logro'],
 [3,5,'Compartir conocimiento abre puertas. Esta semana estoy explorando Machine Learning aplicado a problemas reales de negocios.','2026-01-13T12:15:00Z','Aprendizaje'],
 [4,9,'¿Alguien esta trabajando en proyectos de frontend accesibles? Me encantaria conocer experiencias y buenas practicas.','2026-01-12T09:45:00Z','Pregunta'],
 [5,15,'Estamos buscando una persona de producto para ayudar a construir mejores experiencias de pago para emprendedores del Caribe.','2026-01-11T14:00:00Z','Oportunidad'],
 [6,23,'Despues de varias semanas de experimentos, nuestro modelo ya puede anticipar demanda con resultados prometedores.','2026-01-10T18:20:00Z','Logro'],
 [7,35,'Un recordatorio para equipos: mejorar no siempre significa hacer mas. A veces significa quitar friccion.','2026-01-09T08:30:00Z','Reflexion'],
 [8,39,'Conectar talento con equipos que cuidan la experiencia de las personas sigue siendo mi parte favorita del trabajo.','2026-01-08T11:10:00Z','Comunidad']
] AS r
MATCH (u:Usuario {id:r[1]})
CREATE (p:Publicacion {id:r[0], texto:r[2], fecha:r[3], tipo:r[4]})
CREATE (u)-[:PUBLICA_POST]->(p);

// Comunidades semanticas y pertenencia calculada para la demo
UNWIND [[1,'Backend y Datos','Python, SQL, Machine Learning y plataformas de datos'],[2,'Producto y Diseño','Producto, investigacion, diseño y contenido'],[3,'Cloud y Confiabilidad','Cloud, Linux, Docker, Kubernetes y seguridad'],[4,'Frontend y Mobile','JavaScript, React, accesibilidad y experiencias mobile'],[5,'Tecnologia Caribe','Redes, operaciones y productos nacidos en la region']] AS r
CREATE (:Comunidad {id:r[0], nombre:r[1], descripcion:r[2]});

UNWIND [
 [1,2],[1,4],[1,5],[1,10],[1,22],[1,23],[1,26],[1,31],[1,34],[1,40],
 [2,3],[2,13],[2,15],[2,19],[2,21],[2,25],[2,27],[2,29],[2,33],[2,35],
 [3,6],[3,7],[3,12],[3,16],[3,18],[3,24],[3,30],[3,32],
 [4,9],[4,14],[4,20],[4,28],[4,37],
 [5,1],[5,2],[5,6],[5,8],[5,15],[5,26],[5,36]
] AS r
MATCH (c:Comunidad {id:r[0]}), (u:Usuario {id:r[1]})
CREATE (u)-[:PERTENECE_A]->(c);
