SELECT
    D.Nome AS NomeDepartamento,
    D.CodigoDepartamento,
    P.Nome AS ProfessorChefeNome,
    P.Sobrenome AS ProfessorChefeSobrenome
FROM
    Departamento AS D
JOIN
    Professor AS P ON D.ProfessorChefe_Nome = P.Nome AND D.ProfessorChefe_Sobrenome = P.Sobrenome AND D.ProfessorChefe_Telefone = P.Telefone;