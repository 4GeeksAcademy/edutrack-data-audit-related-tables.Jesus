# Informe de Auditoría — EduTrack v2 (esquema normalizado)

**Base de datos:** `edutrack_v2.sql` importado en Supabase (PostgreSQL)
**Tablas:** `students` (8), `courses` (7), `enrollments` (16)
**Diagrama E/R:** `diagram.png`

## Modelo de datos

- `students` 1:n `enrollments` — un estudiante puede tener muchas inscripciones (`enrollments.student_id` → `students.id`).
- `courses` 1:n `enrollments` — un curso puede tener muchas inscripciones (`enrollments.course_id` → `courses.id`).
- `students` n:m `courses` — relación muchos a muchos resuelta con la tabla intermedia `enrollments`.

---

## 1. Inscripciones con estudiante, curso y % completado
Resultado: 16

| name | title | completion_percentage |
| --- | --- | --- |
| Emily Watson | Intro to Python | 85 |
| Emily Watson | Web Design Basics | 60 |
| Klaus Weber | Intro to Python | 92 |
| Klaus Weber | Data Analysis with SQL | 78 |
| Lucia Fernandes | Web Design Basics | 5 |
| Lucia Fernandes | Digital Marketing 101 | 3 |
| Marco Rossi | Advanced Python | 95 |
| Marco Rossi | Intro to Python | 88 |
| Yuki Nakamura | Data Analysis with SQL | 45 |
| Yuki Nakamura | UI/UX Fundamentals | 0 |
| Pierre Dubois | UI/UX Fundamentals | 0 |
| Priya Sharma | Digital Marketing 101 | 70 |
| Priya Sharma | Intro to Python | 55 |
| Pierre Dubois | Data Analysis with SQL | 20 |
| Emily Watson | Advanced Python | 40 |
| Lucia Fernandes | Advanced Python | 0 |

Giulia Romano no aparece: no tiene inscripciones y el INNER JOIN solo devuelve filas con coincidencia en ambas tablas.

## 2. Estudiantes que han aprobado al menos un curso
Resultado: 6 cursos aprobados (4 estudiantes distintos)

| name | email | title |
| --- | --- | --- |
| Emily Watson | emily.watson@student.edutrack.com | Intro to Python |
| Klaus Weber | klaus.weber@student.edutrack.com | Intro to Python |
| Klaus Weber | klaus.weber@student.edutrack.com | Data Analysis with SQL |
| Marco Rossi | marco.rossi@student.edutrack.com | Advanced Python |
| Marco Rossi | marco.rossi@student.edutrack.com | Intro to Python |
| Priya Sharma | priya.sharma@student.edutrack.com | Digital Marketing 101 |

## 3. Completado medio por instructor (de mayor a menor)
Resultado: 4

| instructor_name | promedio_completado |
| --- | --- |
| Marta López | 66.14 |
| Carlos Vega | 40.00 |
| Lucia Prades | 36.50 |
| Pending assignment | 0.00 |

"Pending assignment" corresponde a UI/UX Fundamentals: el curso sigue sin instructor y sus dos alumnos no han empezado.

## 4. Estudiantes sin ninguna inscripción
Resultado: 1

| id | name | email |
| --- | --- | --- |
| 8 | Giulia Romano | giulia.romano@student.edutrack.com |

Se registró en la plataforma pero nunca se apuntó a un curso.

## 5. Cursos sin ninguna inscripción
Resultado: 1

| id | title | category | instructor_name |
| --- | --- | --- | --- |
| 7 | Email Campaigns | Marketing | Lucia Prades |

Candidato a archivarse, como sugería la responsable de operaciones.

## 6. Estudiantes inscritos en más de un curso
Resultado: 7

| name | num_cursos |
| --- | --- |
| Emily Watson | 3 |
| Lucia Fernandes | 3 |
| Klaus Weber | 2 |
| Marco Rossi | 2 |
| Pierre Dubois | 2 |
| Priya Sharma | 2 |
| Yuki Nakamura | 2 |

Todos los estudiantes con alguna inscripción están en más de un curso.

## 7. Ingresos totales por categoría (precio actual del curso)
Resultado: 4

| category | ingresos_precio_actual |
| --- | --- |
| Programming | 409.93 |
| Data | 179.97 |
| Design | 169.96 |
| Marketing | 59.98 |

Total: 819.84. Programming genera la mitad de los ingresos. Calculado con `courses.monthly_fee`; en este conjunto de datos coincide con lo pagado (`monthly_fee_paid`), porque los precios no han cambiado.

## 8. Instructores y número de estudiantes inscritos
Resultado: 4

| instructor_name | estudiantes_distintos | inscripciones |
| --- | --- | --- |
| Marta López | 6 | 7 |
| Carlos Vega | 3 | 5 |
| Lucia Prades | 2 | 2 |
| Pending assignment | 2 | 2 |

"Estudiantes distintos" cuenta cada alumno una vez aunque esté en varios cursos del mismo instructor.

## 9. Inscripciones huérfanas por student_id
Resultado: 0

Ninguna inscripción apunta a un estudiante inexistente.

## 10. Inscripciones huérfanas por course_id
Resultado: 0

Ninguna inscripción apunta a un curso inexistente. Las claves foráneas (`REFERENCES`) del nuevo esquema impiden crear registros huérfanos.

---

## Conclusiones

- **Integridad:** el esquema normalizado está limpio, sin registros huérfanos. Las claves foráneas lo garantizan.
- **Estudiantes:** 7 de los 8 cursan más de un curso; Giulia Romano está registrada sin inscripciones (posible acción de reactivación).
- **Catálogo:** Email Campaigns no tiene inscripciones y es candidato a archivarse.
- **Rendimiento:** Marta López tiene el mejor completado medio (66.14%). UI/UX Fundamentals sigue sin instructor y con 0% de completado: es el punto más débil.
- **Ingresos:** Programming lidera (409.93) y Marketing es la categoría que menos ingresa (59.98).

