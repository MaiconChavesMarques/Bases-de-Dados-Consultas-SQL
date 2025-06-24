SELECT
    A.Nome,
    A.Sobrenome,
    A.Telefone
FROM
    Aluno AS A
JOIN
    Matricula AS M ON A.Nome = M.Aluno_Nome AND A.Sobrenome = M.Aluno_Sobrenome AND A.Telefone = M.Aluno_Telefone
JOIN
    Periodo_Letivo AS PL ON M.Data = PL.Data
WHERE
    M.Sigla = 'FIS101' AND PL.PeriodoLetivo = '2023-1';