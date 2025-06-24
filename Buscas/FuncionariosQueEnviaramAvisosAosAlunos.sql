SELECT DISTINCT
    FA.Nome AS AdminNome,
    FA.Sobrenome AS AdminSobrenome
FROM
    Funcionario_Administrativo AS FA
JOIN
    Avisos_Gerais AS AG ON FA.Nome = AG.Admin_Nome AND FA.Sobrenome = AG.Admin_Sobrenome AND FA.Telefone = AG.Admin_Telefone
JOIN
    Usuarios AS U ON AG.Usuario_Nome = U.Nome AND AG.Usuario_Sobrenome = U.Sobrenome AND AG.Usuario_Telefone = U.Telefone
WHERE
    U.Tipo = 'Aluno';