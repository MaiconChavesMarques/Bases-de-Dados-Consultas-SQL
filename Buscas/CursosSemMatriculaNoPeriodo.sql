SELECT
    C.Nome AS NomeCurso,
    C.CodigoCurso
FROM
    Cursos AS C
LEFT JOIN
    Matricula AS M ON C.CodigoCurso = (
        SELECT CodigoCurso FROM Cursos WHERE CodigoCurso = (
            SELECT CursoIngresso FROM PreRequisitos_Disciplinas WHERE DisciplinaPreRequisito = M.Sigla LIMIT 1
        ) LIMIT 1
    )
LEFT JOIN
    Periodo_Letivo AS PL ON M.Data = PL.Data
WHERE
    C.CodigoCurso NOT IN (
        SELECT M2.Sigla FROM Matricula AS M2 JOIN Periodo_Letivo AS PL2 ON M2.Data = PL2.Data WHERE PL2.PeriodoLetivo = '2023-1'
    )
GROUP BY
    C.Nome, C.CodigoCurso
HAVING
    COUNT(M.Data) = 0 OR MAX(PL.PeriodoLetivo) IS NULL OR MAX(PL.PeriodoLetivo) < '2023-1';