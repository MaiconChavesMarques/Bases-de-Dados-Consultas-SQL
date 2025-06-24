SELECT
    P.Nome AS ProfessorNome,
    P.Sobrenome AS ProfessorSobrenome,
    D.Sigla AS DisciplinaSigla,
    D.ProfessorNome AS DisciplinaProfessorNome -- This column actually stores the professor's name, confirming responsibility
FROM
    Professor AS P
JOIN
    Disciplina AS D ON P.Nome = D.ProfessorNome AND P.Sobrenome = D.ProfessorSobrenome AND P.Telefone = D.ProfessorTelefone
WHERE
    P.CodigoDepartamento = 'ICMC-COMP';