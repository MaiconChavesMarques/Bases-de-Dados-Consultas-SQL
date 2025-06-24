SELECT
    MPA.Remetente_Nome,
    MPA.Remetente_Sobrenome,
    MPA.Timestamp,
    MPA.Texto,
    MPA.Destinatario_Nome,
    MPA.Destinatario_Sobrenome
FROM
    Mensagem_Professor_Aluno AS MPA
WHERE
    MPA.Remetente_Nome = 'Henrique' AND MPA.Remetente_Sobrenome = 'Moura';