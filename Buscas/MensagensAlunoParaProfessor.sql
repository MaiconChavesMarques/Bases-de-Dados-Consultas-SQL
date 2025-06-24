SELECT
    MP.Timestamp,
    MP.Texto,
    MP.Destinatario_Nome AS ProfessorNome,
    MP.Destinatario_Sobrenome AS ProfessorSobrenome
FROM
    Mensagem_Aluno_Professor AS MP
WHERE
    MP.Remetente_Nome = 'João Gabriel' AND MP.Remetente_Sobrenome = 'Jesus' AND MP.Remetente_Telefone = '2182400842';