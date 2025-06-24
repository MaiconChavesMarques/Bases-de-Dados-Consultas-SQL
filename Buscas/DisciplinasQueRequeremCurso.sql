SELECT
    D.Sigla AS DisciplinaSigla,
    D.CapacidadeTurma
FROM
    Disciplina AS D
JOIN
    PreRequisitos_Disciplinas AS PRD ON D.Sigla = PRD.DisciplinaPreRequisito
WHERE
    PRD.CursoIngresso = 'CC-BACH21';