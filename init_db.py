"""Carga los datos de ejemplo en Neo4j.  Uso: python init_db.py
Variables opcionales: NEO4J_URI, NEO4J_USER, NEO4J_PASS"""
import os
from neo4j import GraphDatabase
from werkzeug.security import generate_password_hash

d = GraphDatabase.driver(os.getenv("NEO4J_URI", "bolt://localhost:7687"),
                         auth=(os.getenv("NEO4J_USER", "neo4j"), os.getenv("NEO4J_PASS", "12345678")))
with d.session() as s:
    # borra solo los nodos de esta app (no toca otras bases de datos tuyas)
    s.run("MATCH (n) WHERE n:Usuario OR n:Empresa OR n:Habilidad OR n:Proyecto OR n:Oferta DETACH DELETE n").consume()
    texto = "\n".join(l for l in open("seed.cypher", encoding="utf-8").read().splitlines() if not l.strip().startswith("//"))
    clave = generate_password_hash("demo123")
    for sentencia in texto.split(";\n"):
        if sentencia.strip().strip(";"):
            s.run(sentencia.strip().strip(";"), clave=clave).consume()
print("Listo. Entra con valentina@demo.com / demo123")
