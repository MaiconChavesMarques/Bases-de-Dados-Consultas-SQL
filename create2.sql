DROP TABLE IF EXISTS
    Avisos_Gerais,
    Mensagem_Aluno_Professor,
    Mensagem_Professor_Aluno,
    NotaProfessor,
    NotaDisciplina,
    Periodo_Letivo,
    Matricula,
    Funcionario_Administrativo,
    Aluno,
    Necessidade_Infraestrutura,
    Regras,
    Material_Didatico,
    PreRequisitos_Disciplinas,
    Disciplina,
    PreRequisitos_Cursos,
    Cursos,
    Professor,
    Usuarios,
    Departamento,
    Unidade
CASCADE;

CREATE TABLE Unidade (
    Nome VARCHAR(100) PRIMARY KEY,
    Cidade VARCHAR(50),
    Estado VARCHAR(50),
    Pais VARCHAR(50),
    Predio VARCHAR(20),
    Bloco VARCHAR(20)
);

CREATE TABLE Departamento (
    Nome VARCHAR(100),
    CodigoDepartamento VARCHAR(20) PRIMARY KEY,
    ProfessorChefe_Nome VARCHAR(100),
    ProfessorChefe_Sobrenome VARCHAR(100),
    ProfessorChefe_Telefone VARCHAR(15)
);

CREATE TABLE Usuarios (
    Nome VARCHAR(100),
    Sobrenome VARCHAR(100),
    Telefone VARCHAR(15),
    DataNascimento DATE,
    Pais VARCHAR(50),
    Estado VARCHAR(50),
    Cidade VARCHAR(50),
    Bairro VARCHAR(50),
    Rua VARCHAR(100),
    Numero VARCHAR(20),
    Sexo CHAR(1) CHECK (Sexo IN ('M', 'F', 'O')),
    Email VARCHAR(100),
    Senha VARCHAR(100),
    Tipo VARCHAR(20) CHECK (Tipo IN ('Aluno', 'Professor', 'Funcionario')),
    PRIMARY KEY (Nome, Sobrenome, Telefone)
);

CREATE TABLE Professor (
    Nome VARCHAR(100),
    Sobrenome VARCHAR(100),
    Telefone VARCHAR(15),
    Especializacao VARCHAR(100),
    Titulacao VARCHAR(50),
    Unidade VARCHAR(100),
    CodigoDepartamento VARCHAR(20),
    PRIMARY KEY (Nome, Sobrenome, Telefone),
    FOREIGN KEY (Nome, Sobrenome, Telefone) REFERENCES Usuarios(Nome, Sobrenome, Telefone),
    FOREIGN KEY (Unidade) REFERENCES Unidade(Nome),
    FOREIGN KEY (CodigoDepartamento) REFERENCES Departamento(CodigoDepartamento)
);

CREATE TABLE Cursos (
    Nome VARCHAR(100),
    CodigoCurso VARCHAR(20) PRIMARY KEY,
    CodigoDepartamento VARCHAR(20),
    Nivel VARCHAR(20) CHECK (Nivel IN ('Fundamental', 'Médio', 'Técnico', 'Graduação', 'Pós-graduação')),
    CargaHorariaTotal INT,
    Vagas INT,
    SalaAula VARCHAR(20),
    NomeUnidade VARCHAR(100),
    FOREIGN KEY (CodigoDepartamento) REFERENCES Departamento(CodigoDepartamento),
    FOREIGN KEY (NomeUnidade) REFERENCES Unidade(Nome)
);

CREATE TABLE PreRequisitos_Cursos (
    CursoIngresso VARCHAR(20),
    CursoPreRequisito VARCHAR(20),
    PRIMARY KEY (CursoIngresso, CursoPreRequisito),
    FOREIGN KEY (CursoIngresso) REFERENCES Cursos(CodigoCurso),
    FOREIGN KEY (CursoPreRequisito) REFERENCES Cursos(CodigoCurso)
);

CREATE TABLE Disciplina (
    Sigla VARCHAR(20) PRIMARY KEY,
    QuantidadeAulasSemanais INT,
    CapacidadeTurma INT,
    ProfessorNome VARCHAR(100),
    ProfessorSobrenome VARCHAR(100),
    ProfessorTelefone VARCHAR(15),
    NomeUnidade VARCHAR(100),
    FOREIGN KEY (ProfessorNome, ProfessorSobrenome, ProfessorTelefone) REFERENCES Professor(Nome, Sobrenome, Telefone),
    FOREIGN KEY (NomeUnidade) REFERENCES Unidade(Nome)
);

CREATE TABLE PreRequisitos_Disciplinas (
    CursoIngresso VARCHAR(20),
    DisciplinaPreRequisito VARCHAR(20),
    PRIMARY KEY (CursoIngresso, DisciplinaPreRequisito),
    FOREIGN KEY (CursoIngresso) REFERENCES Cursos(CodigoCurso),
    FOREIGN KEY (DisciplinaPreRequisito) REFERENCES Disciplina(Sigla)
);

CREATE TABLE Material_Didatico (
    Sigla VARCHAR(20),
    MaterialDidatico VARCHAR(100),
    PRIMARY KEY (Sigla, MaterialDidatico),
    FOREIGN KEY (Sigla) REFERENCES Disciplina(Sigla)
);

CREATE TABLE Regras (
    Sigla VARCHAR(20),
    Regra VARCHAR(100),
    PRIMARY KEY (Sigla, Regra),
    FOREIGN KEY (Sigla) REFERENCES Disciplina(Sigla)
);

CREATE TABLE Necessidade_Infraestrutura (
    Sigla VARCHAR(20),
    Infraestrutura VARCHAR(100),
    PRIMARY KEY (Sigla, Infraestrutura),
    FOREIGN KEY (Sigla) REFERENCES Disciplina(Sigla)
);

CREATE TABLE Aluno (
    Nome VARCHAR(100),
    Sobrenome VARCHAR(100),
    Telefone VARCHAR(15),
    Unidade VARCHAR(100),
    PRIMARY KEY (Nome, Sobrenome, Telefone),
    FOREIGN KEY (Nome, Sobrenome, Telefone) REFERENCES Usuarios(Nome, Sobrenome, Telefone),
    FOREIGN KEY (Unidade) REFERENCES Unidade(Nome)
);

CREATE TABLE Funcionario_Administrativo (
    Nome VARCHAR(100),
    Sobrenome VARCHAR(100),
    Telefone VARCHAR(15),
    Unidade VARCHAR(100),
    PRIMARY KEY (Nome, Sobrenome, Telefone),
    FOREIGN KEY (Nome, Sobrenome, Telefone) REFERENCES Usuarios(Nome, Sobrenome, Telefone),
    FOREIGN KEY (Unidade) REFERENCES Unidade(Nome)
);

CREATE TABLE Matricula (
    Data DATE,
    Aluno_Nome VARCHAR(100),
    Aluno_Sobrenome VARCHAR(100),
    Aluno_Telefone VARCHAR(15),
    Sigla VARCHAR(20),
    Status VARCHAR(20) CHECK (Status IN ('Ativa', 'Trancada', 'Cancelada', 'Concluída')),
    Notas DECIMAL(4,2),
    DescontoBolsa DECIMAL(7,2),
    Taxa DECIMAL(7,2),
    DataLimite DATE,
    PRIMARY KEY (Data, Aluno_Nome, Aluno_Sobrenome, Aluno_Telefone, Sigla),
    FOREIGN KEY (Aluno_Nome, Aluno_Sobrenome, Aluno_Telefone) REFERENCES Aluno(Nome, Sobrenome, Telefone),
    FOREIGN KEY (Sigla) REFERENCES Disciplina(Sigla)
);

CREATE TABLE Periodo_Letivo (
    Data DATE,
    PeriodoLetivo VARCHAR(20),
    PRIMARY KEY (Data, PeriodoLetivo)
);

CREATE TABLE NotaDisciplina (
    Aluno_Nome VARCHAR(100),
    Aluno_Sobrenome VARCHAR(100),
    Aluno_Telefone VARCHAR(15),
    Sigla VARCHAR(20),
    PeriodoLetivo VARCHAR(20),
    Texto TEXT,
    NotaDidatica INT CHECK (NotaDidatica BETWEEN 0 AND 20),
    NotaMaterial INT CHECK (NotaMaterial BETWEEN 0 AND 20),
    NotaConteudo INT CHECK (NotaConteudo BETWEEN 0 AND 20),
    NotaInfraestrutura INT CHECK (NotaInfraestrutura BETWEEN 0 AND 20),
    PRIMARY KEY (Aluno_Nome, Aluno_Sobrenome, Aluno_Telefone, Sigla, PeriodoLetivo),
    FOREIGN KEY (Aluno_Nome, Aluno_Sobrenome, Aluno_Telefone) REFERENCES Aluno(Nome, Sobrenome, Telefone),
    FOREIGN KEY (Sigla) REFERENCES Disciplina(Sigla)
);

CREATE TABLE NotaProfessor (
    Aluno_Nome VARCHAR(100),
    Aluno_Sobrenome VARCHAR(100),
    Aluno_Telefone VARCHAR(15),
    Professor_Nome VARCHAR(100),
    Professor_Sobrenome VARCHAR(100),
    Professor_Telefone VARCHAR(15),
    PeriodoLetivo VARCHAR(20),
    Texto TEXT,
    NotaDidaticaProfessor INT CHECK (NotaDidaticaProfessor BETWEEN 0 AND 20),
    PRIMARY KEY (Aluno_Nome, Aluno_Sobrenome, Aluno_Telefone, Professor_Nome, Professor_Sobrenome, Professor_Telefone, PeriodoLetivo),
    FOREIGN KEY (Aluno_Nome, Aluno_Sobrenome, Aluno_Telefone) REFERENCES Aluno(Nome, Sobrenome, Telefone),
    FOREIGN KEY (Professor_Nome, Professor_Sobrenome, Professor_Telefone) REFERENCES Professor(Nome, Sobrenome, Telefone)
);

CREATE TABLE Mensagem_Professor_Aluno (
    Remetente_Nome VARCHAR(100),
    Remetente_Sobrenome VARCHAR(100),
    Remetente_Telefone VARCHAR(15),
    Destinatario_Nome VARCHAR(100),
    Destinatario_Sobrenome VARCHAR(100),
    Destinatario_Telefone VARCHAR(15),
    Timestamp TIMESTAMP,
    Texto TEXT,
    PRIMARY KEY (Remetente_Nome, Remetente_Sobrenome, Remetente_Telefone, Destinatario_Nome, Destinatario_Sobrenome, Destinatario_Telefone, Timestamp),
    FOREIGN KEY (Remetente_Nome, Remetente_Sobrenome, Remetente_Telefone) REFERENCES Professor(Nome, Sobrenome, Telefone),
    FOREIGN KEY (Destinatario_Nome, Destinatario_Sobrenome, Destinatario_Telefone) REFERENCES Aluno(Nome, Sobrenome, Telefone)
);

CREATE TABLE Mensagem_Aluno_Professor (
    Remetente_Nome VARCHAR(100),
    Remetente_Sobrenome VARCHAR(100),
    Remetente_Telefone VARCHAR(15),
    Destinatario_Nome VARCHAR(100),
    Destinatario_Sobrenome VARCHAR(100),
    Destinatario_Telefone VARCHAR(15),
    Timestamp TIMESTAMP,
    Texto TEXT,
    PRIMARY KEY (Remetente_Nome, Remetente_Sobrenome, Remetente_Telefone, Destinatario_Nome, Destinatario_Sobrenome, Destinatario_Telefone, Timestamp),
    FOREIGN KEY (Remetente_Nome, Remetente_Sobrenome, Remetente_Telefone) REFERENCES Aluno(Nome, Sobrenome, Telefone),
    FOREIGN KEY (Destinatario_Nome, Destinatario_Sobrenome, Destinatario_Telefone) REFERENCES Professor(Nome, Sobrenome, Telefone)
);

CREATE TABLE Avisos_Gerais (
    Admin_Nome VARCHAR(100),
    Admin_Sobrenome VARCHAR(100),
    Admin_Telefone VARCHAR(15),
    Usuario_Nome VARCHAR(100),
    Usuario_Sobrenome VARCHAR(100),
    Usuario_Telefone VARCHAR(15),
    Timestamp TIMESTAMP,
    Texto TEXT,
    PRIMARY KEY (Admin_Nome, Admin_Sobrenome, Admin_Telefone, Usuario_Nome, Usuario_Sobrenome, Usuario_Telefone, Timestamp),
    FOREIGN KEY (Admin_Nome, Admin_Sobrenome, Admin_Telefone) REFERENCES Funcionario_Administrativo(Nome, Sobrenome, Telefone),
    FOREIGN KEY (Usuario_Nome, Usuario_Sobrenome, Usuario_Telefone) REFERENCES Usuarios(Nome, Sobrenome, Telefone)
);