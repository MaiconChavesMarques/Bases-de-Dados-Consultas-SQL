SELECT
    NP.Aluno_Nome,
    NP.Aluno_Sobrenome,
    NP.Professor_Nome,
    NP.Professor_Sobrenome,
    NP.NotaDidaticaProfessor,
    NP.Texto
FROM
    NotaProfessor AS NP
WHERE
    NP.Aluno_Nome = 'João Gabriel' AND NP.Aluno_Sobrenome = 'Jesus';