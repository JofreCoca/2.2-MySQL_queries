
-- 1 Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1, apellido2, nombre
FROM persona
WHERE tipo = 'alumno'
ORDER BY apellido1, apellido2, nombre;
-- 2 Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT apellido1, apellido2, nombre
FROM persona
WHERE tipo = 'alumno' AND telefono IS NULL
ORDER BY apellido1, apellido2, nombre;
-- 3 Retorna el llistat dels alumnes que van néixer en 1999.
SELECT apellido1, apellido2, nombre
FROM persona
WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999
ORDER BY apellido1, apellido2, nombre;
-- 4 Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.
SELECT apellido1, apellido2, nombre, nif
FROM persona
WHERE tipo = 'profesor' 
  AND telefono IS NULL
  AND nif LIKE '%K'
ORDER BY apellido1, apellido2, nombre;
-- 5 Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT asignatura.nombre
FROM asignatura
JOIN grado ON asignatura.id_grado = grado.id
WHERE grado.id = 7
  AND asignatura.curso = 3
  AND asignatura.cuatrimestre = 1
ORDER BY asignatura.nombre;
-- 6 Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre AS nombre_departamento
FROM persona p
JOIN profesor pr ON p.id = pr.id_profesor
JOIN departamento d ON pr.id_departamento = d.id
WHERE p.tipo = 'profesor'
ORDER BY p.apellido1, p.apellido2, p.nombre;
-- 8 Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT DISTINCT d.nombre AS nom_departament
FROM departamento d
JOIN profesor pr ON d.id = pr.id_departamento
JOIN asignatura a ON pr.id_profesor = a.id_profesor
JOIN grado g ON a.id_grado = g.id
WHERE g.nombre = 'Grau en Enginyeria Informàtica (Pla 2015)'
ORDER BY d.nombre;

--  clàusules LEFT JOIN i RIGHT JOIN.

-- 1 Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
SELECT 
    COALESCE(d.nombre, 'Sense Departament') AS nom_departament,
    p.apellido1 AS primer_cognom,
    p.apellido2 AS segon_cognom,
    p.nombre AS nom_professor
FROM persona p
LEFT JOIN profesor pr ON p.id = pr.id_profesor
LEFT JOIN departamento d ON pr.id_departamento = d.id
WHERE p.tipo = 'profesor'
ORDER BY nom_departament, primer_cognom, segon_cognom, nom_professor;
-- 2 Retorna un llistat amb els professors/es que no estan associats a un departament.
SELECT p.apellido1 AS primer_cognom, p.apellido2 AS segon_cognom, p.nombre AS nom_professor
FROM persona p
LEFT JOIN profesor pr ON p.id = pr.id_profesor
WHERE p.tipo = 'profesor' AND pr.id_departamento IS NULL
ORDER BY p.apellido1, p.apellido2, p.nombre;
-- 3 Retorna un llistat amb els departaments que no tenen professors/es associats.
SELECT d.nombre AS nom_departament
FROM departamento d
LEFT JOIN profesor pr ON d.id = pr.id_departamento
WHERE pr.id_profesor IS NULL
ORDER BY d.nombre;
-- 4 Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
SELECT p.apellido1 AS primer_cognom, p.apellido2 AS segon_cognom, p.nombre AS nom_professor
FROM persona p
JOIN profesor pr ON p.id = pr.id_profesor
LEFT JOIN asignatura a ON pr.id_profesor = a.id_profesor
WHERE p.tipo = 'profesor' AND a.id IS NULL
ORDER BY p.apellido1, p.apellido2, p.nombre;
-- 5 Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
SELECT a.nombre AS nom_assignatura
FROM asignatura a
LEFT JOIN profesor pr ON a.id_profesor = pr.id_profesor
WHERE pr.id_profesor IS NULL
ORDER BY a.nombre;
-- 6 Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT DISTINCT d.nombre AS nom_departament
FROM departamento d
LEFT JOIN profesor pr ON d.id = pr.id_departamento
LEFT JOIN asignatura a ON pr.id_profesor = a.id_profesor
WHERE a.id IS NULL
ORDER BY d.nombre;

-- Consultes resum

-- 1 Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(*) AS total_alumnes
FROM persona
WHERE tipo = 'alumno';
-- 2 Calcula quants alumnes van néixer en 1999.
SELECT COUNT(*) AS total_alumnes_1999
FROM persona
WHERE tipo = 'alumno' AND YEAR(fecha_nacimiento) = 1999;
-- 3 Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.
SELECT d.nombre AS nom_departament, COUNT(pr.id_profesor) AS num_professors
FROM departamento d
JOIN profesor pr ON d.id = pr.id_departamento
GROUP BY d.nombre
HAVING COUNT(pr.id_profesor) > 0
ORDER BY num_professors DESC;
-- 4 Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat.
SELECT d.nombre AS nom_departament, COUNT(pr.id_profesor) AS num_professors
FROM departamento d
LEFT JOIN profesor pr ON d.id = pr.id_departamento
GROUP BY d.nombre
ORDER BY d.nombre;
-- 5 Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT g.nombre AS nom_grau, COUNT(a.id) AS num_assignatures
FROM grado g
LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre
ORDER BY num_assignatures DESC;
-- 6 Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
SELECT g.nombre AS nom_grau, COUNT(a.id) AS num_assignatures
FROM grado g
LEFT JOIN asignatura a ON g.id = a.id_grado
GROUP BY g.nombre
HAVING COUNT(a.id) > 40
ORDER BY num_assignatures DESC;
-- 9 Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
SELECT 
    p.id AS id_professor,
    p.nombre AS nom,
    p.apellido1 AS primer_cognom,
    p.apellido2 AS segon_cognom,
    COUNT(a.id) AS num_assignatures
FROM persona p
LEFT JOIN profesor pr ON p.id = pr.id_profesor
LEFT JOIN asignatura a ON pr.id_profesor = a.id_profesor
WHERE p.tipo = 'profesor'
GROUP BY p.id, p.nombre, p.apellido1, p.apellido2
ORDER BY num_assignatures DESC;
-- 10 Retorna totes les dades de l'alumne/a més jove.
SELECT *
FROM persona
WHERE tipo = 'alumno'
ORDER BY fecha_nacimiento DESC
LIMIT 1;
-- 11 Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.
SELECT 
    p.id AS id_professor,
    p.nombre AS nom,
    p.apellido1 AS primer_cognom,
    p.apellido2 AS segon_cognom,
    d.nombre AS nom_departament
FROM persona p
JOIN profesor pr ON p.id = pr.id_profesor
JOIN departamento d ON pr.id_departamento = d.id
LEFT JOIN asignatura a ON pr.id_profesor = a.id_profesor
WHERE p.tipo = 'profesor' AND a.id IS NULL
ORDER BY p.apellido1, p.apellido2, p.nombre;





