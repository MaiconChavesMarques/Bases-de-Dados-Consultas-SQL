CREATE INDEX idx_matricula_sigla_data 
ON Matricula (Sigla, Data);

CREATE INDEX idx_usuarios_aluno
ON Usuarios (Nome, Sobrenome, Telefone)
WHERE Tipo = 'Aluno';

CREATE INDEX idx_disciplina_professor
ON Disciplina (ProfessorNome, ProfessorSobrenome, ProfessorTelefone);
