-- ============================================================
-- EduTrack v2 — Auditoría con tablas relacionadas
-- Todas las consultas usan al menos un JOIN y ninguna subconsulta.
-- ============================================================


-- ------------------------------------------------------------
-- INNER JOIN
-- ------------------------------------------------------------

-- 1. Inscripciones con nombre del estudiante, curso y % completado (INNER JOIN)
SELECT students.name, courses.title, enrollments.completion_percentage
FROM enrollments
INNER JOIN students ON enrollments.student_id = students.id
INNER JOIN courses ON enrollments.course_id = courses.id
ORDER BY enrollments.id;

-- 2. Estudiantes que han aprobado al menos un curso (INNER JOIN)
SELECT students.name, students.email, courses.title
FROM enrollments
INNER JOIN students ON enrollments.student_id = students.id
INNER JOIN courses ON enrollments.course_id = courses.id
WHERE enrollments.passed = true
ORDER BY enrollments.id;

-- 3. Completado medio por instructor, de mayor a menor (INNER JOIN + GROUP BY)
SELECT courses.instructor_name, ROUND(AVG(enrollments.completion_percentage), 2) AS promedio_completado
FROM enrollments
INNER JOIN courses ON enrollments.course_id = courses.id
GROUP BY courses.instructor_name
ORDER BY promedio_completado DESC;


-- ------------------------------------------------------------
-- LEFT JOIN (detección de datos faltantes)
-- ------------------------------------------------------------

-- 4. Estudiantes sin ninguna inscripción (LEFT JOIN)
SELECT students.id, students.name, students.email
FROM students
LEFT JOIN enrollments ON students.id = enrollments.student_id
WHERE enrollments.id IS NULL;

-- 5. Cursos sin ninguna inscripción (LEFT JOIN)
SELECT courses.id, courses.title, courses.category, courses.instructor_name
FROM courses
LEFT JOIN enrollments ON courses.id = enrollments.course_id
WHERE enrollments.id IS NULL;


-- ------------------------------------------------------------
-- Agregación entre tablas
-- ------------------------------------------------------------

-- 6. Estudiantes inscritos en más de un curso (INNER JOIN + GROUP BY + HAVING)
SELECT students.name, COUNT(enrollments.course_id) AS num_cursos
FROM students
INNER JOIN enrollments ON students.id = enrollments.student_id
GROUP BY students.id, students.name
HAVING COUNT(enrollments.course_id) > 1
ORDER BY num_cursos DESC, students.name;

-- 7. Ingresos totales por categoría con el precio actual del curso (courses.monthly_fee)
SELECT courses.category, SUM(courses.monthly_fee) AS ingresos_precio_actual
FROM enrollments
INNER JOIN courses ON enrollments.course_id = courses.id
GROUP BY courses.category
ORDER BY ingresos_precio_actual DESC;

-- 8. Instructores con el número de estudiantes inscritos en sus cursos
SELECT courses.instructor_name,
       COUNT(DISTINCT enrollments.student_id) AS estudiantes_distintos,
       COUNT(enrollments.id) AS inscripciones
FROM courses
INNER JOIN enrollments ON courses.id = enrollments.course_id
GROUP BY courses.instructor_name
ORDER BY estudiantes_distintos DESC, courses.instructor_name;


-- ------------------------------------------------------------
-- Integridad de datos
-- ------------------------------------------------------------

-- 9. Inscripciones huérfanas: student_id sin estudiante existente (LEFT JOIN)
SELECT enrollments.id, enrollments.student_id
FROM enrollments
LEFT JOIN students ON enrollments.student_id = students.id
WHERE students.id IS NULL;

-- 10. Inscripciones huérfanas: course_id sin curso existente (LEFT JOIN)
SELECT enrollments.id, enrollments.course_id
FROM enrollments
LEFT JOIN courses ON enrollments.course_id = courses.id
WHERE courses.id IS NULL;