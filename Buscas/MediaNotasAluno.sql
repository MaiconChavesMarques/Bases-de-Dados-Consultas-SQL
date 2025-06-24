SELECT
    A.Nome,
    A.Sobrenome,
    AVG(ND.NotaConteudo) AS MediaNotas
FROM
    Aluno AS A
JOIN
    NotaDisciplina AS ND ON A.Nome = ND.Aluno_Nome AND A.Sobrenome = ND.Aluno_Sobrenome AND A.Telefone = ND.Aluno_Telefone
WHERE
    A.Nome = 'João Gabriel' AND A.Sobrenome = 'Jesus' AND A.Telefone = '2182400842'
GROUP BY
    A.Nome, A.Sobrenome;