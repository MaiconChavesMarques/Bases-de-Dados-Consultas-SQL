CREATE TABLE Locador (
    CPF VARCHAR(14) PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Sobrenome VARCHAR(50) NOT NULL,
    DataNascimento DATE NOT NULL,
    Endereco VARCHAR(255),
    Sexo CHAR(1),
    NumeroTelefone VARCHAR(15),
    Email VARCHAR(100),
    Senha VARCHAR(100)
);

CREATE TABLE Locatario (
    CPF VARCHAR(14) PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Sobrenome VARCHAR(50) NOT NULL,
    DataNascimento DATE NOT NULL,
    Endereco VARCHAR(255),
    Sexo CHAR(1),
    NumeroTelefone VARCHAR(15),
    Email VARCHAR(100),
    Senha VARCHAR(100)
);

CREATE TABLE Propriedade (
    Nome VARCHAR(255),
    Endereco VARCHAR(255),
    TipoDeAluguel VARCHAR(50),
    NumeroDeQuartos INT,
    PrecoPorNoite FLOAT,
    LocadorCPF CHAR(14),
    NumeroDeBanheiros INT,
    NumeroMaximoHospedes INT,
    NumeroMaximoNoites INT,
    NumeroMinimoNoites INT,
    TaxaLimpeza FLOAT,
    DataDisponibilidade DATE,
    HorarioEntrada TIME,
    HorarioSaida TIME,
    PRIMARY KEY (Endereco),
    FOREIGN KEY (LocadorCPF) REFERENCES Locador(CPF)
);

CREATE TABLE Quarto (
    PropriedadeEndereco VARCHAR(255) NOT NULL,
    NumeroQuarto INT NOT NULL,
    NumeroCamas INT NOT NULL,
    BanheiroPrivativo BOOLEAN NOT NULL,
    PRIMARY KEY (PropriedadeEndereco, NumeroQuarto),
    FOREIGN KEY (PropriedadeEndereco) REFERENCES Propriedade(Endereco)
);

CREATE TABLE Reserva (
    NumeroReserva VARCHAR(10) PRIMARY KEY,
    DataCheckIn DATE,
    DataCheckOut DATE,
    DataReserva DATE,
    NumeroHospedes INT,
    PropriedadeEndereco VARCHAR(255),
    LocatarioCPF VARCHAR(14),
    Imposto FLOAT,
    PrecoTotal FLOAT,
    Confirmada BOOLEAN,
    FOREIGN KEY (PropriedadeEndereco) REFERENCES Propriedade(Endereco),
    FOREIGN KEY (LocatarioCPF) REFERENCES Locatario(CPF)
);

CREATE TABLE ContaBancaria (
    NumeroConta CHAR(10) PRIMARY KEY,
    LocadorCPF VARCHAR(14) NOT NULL,
    Agencia INT NOT NULL,
    TipoConta VARCHAR(20) NOT NULL,
    FOREIGN KEY (LocadorCPF) REFERENCES Locador(CPF)
);

CREATE TABLE Localizacao (
    PropriedadeEndereco VARCHAR(255),
    CEP CHAR(10),
    Numero INT,
    Cidade VARCHAR(100),
    Estado CHAR(2),
    Pais VARCHAR(100),
    Bairro VARCHAR(100),
    PontosDeInteresse VARCHAR(255),
    PRIMARY KEY (PropriedadeEndereco),
    FOREIGN KEY (PropriedadeEndereco) REFERENCES Propriedade(Endereco)
);

CREATE TABLE Avaliacao (
    PropriedadeEndereco VARCHAR(255),
    NumeroAvaliacao INT,
    Mensagem TEXT,
    Fotos JSON,
    Limpeza INT,
    ClassificacaoLimpeza INT,
    LocatarioCPF CHAR(14),
    ClassificacaoEstrutura INT,
    NotasParaAnfitriao INT,
    NotasParaLocalizacao INT,
    NotasParaValor INT,
    PRIMARY KEY (PropriedadeEndereco, NumeroAvaliacao),
    FOREIGN KEY (PropriedadeEndereco) REFERENCES Propriedade(Endereco),
    FOREIGN KEY (LocatarioCPF) REFERENCES Locatario(CPF)
);

CREATE TABLE Mensagem (
    Remetente VARCHAR(100) NOT NULL,
    Data DATE NOT NULL,
    Hora TIME NOT NULL,
    Destinatario VARCHAR(100) NOT NULL,
    Texto TEXT,
    PRIMARY KEY (Remetente, Data, Hora, Destinatario)
);

CREATE TABLE Envia (
    Remetente VARCHAR(255),
    Data DATE,
    Hora TIME,
    Destinatario VARCHAR(255),
    LocadorCPF CHAR(14),
    LocatarioCPF CHAR(14),
    PRIMARY KEY (Remetente, Data, Hora, Destinatario),
    FOREIGN KEY (LocadorCPF) REFERENCES Locador(CPF),
    FOREIGN KEY (LocatarioCPF) REFERENCES Locatario(CPF)
);

CREATE TABLE Pesquisa (
    LocatarioCPF CHAR(14),
    PropriedadeEndereco VARCHAR(255),
    PRIMARY KEY (LocatarioCPF, PropriedadeEndereco),
    FOREIGN KEY (LocatarioCPF) REFERENCES Locatario(CPF),
    FOREIGN KEY (PropriedadeEndereco) REFERENCES Propriedade(Endereco)
);

CREATE TABLE Deposita (
    LocadorCPF CHAR(14),
    LocatarioCPF CHAR(14),
    Valor FLOAT,
    PRIMARY KEY (LocadorCPF, LocatarioCPF),
    FOREIGN KEY (LocadorCPF) REFERENCES Locador(CPF),
    FOREIGN KEY (LocatarioCPF) REFERENCES Locatario(CPF)
);
