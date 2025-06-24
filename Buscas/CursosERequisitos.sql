SELECT
    PRC.CursoIngresso,
    C1.Nome AS NomeCursoIngresso,
    PRC.CursoPreRequisito,
    C2.Nome AS NomeCursoPreRequisito
FROM
    PreRequisitos_Cursos AS PRC
JOIN
    Cursos AS C1 ON PRC.CursoIngresso = C1.CodigoCurso
JOIN
    Cursos AS C2 ON PRC.CursoPreRequisito = C2.CodigoCurso;