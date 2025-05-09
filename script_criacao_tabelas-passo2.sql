CREATE TABLE Locador (
    CPF VARCHAR(14) PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Sobrenome VARCHAR(50) NOT NULL,
    DataNascimento DATE NOT NULL,
    Rua VARCHAR(100),
    Numero VARCHAR(10),
    Bairro VARCHAR(100),
    Cidade VARCHAR(100),
    Estado CHAR(2),
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
    Rua VARCHAR(100),
    Numero VARCHAR(10),
    Bairro VARCHAR(100),
    Cidade VARCHAR(100),
    Estado CHAR(2),
    Sexo CHAR(1),
    NumeroTelefone VARCHAR(15),
    Email VARCHAR(100),
    Senha VARCHAR(100)
);

CREATE TABLE Propriedade (
    Nome VARCHAR(255),
    Rua VARCHAR(100),
    Numero VARCHAR(10),
    Bairro VARCHAR(100),
    Cidade VARCHAR(100),
    Estado CHAR(2),
    TipoDeAluguel VARCHAR(50),
    NumeroDeQuartos INT,
    PrecoPorNoite DECIMAL(10, 2),
    LocadorCPF CHAR(14),
    NumeroDeBanheiros INT,
    NumeroMaximoHospedes INT,
    NumeroMaximoNoites INT,
    NumeroMinimoNoites INT,
    TaxaLimpeza DECIMAL(10, 2),
    DataDisponibilidade DATE,
    HorarioEntrada TIME,
    HorarioSaida TIME,
    PRIMARY KEY (Rua, Numero, Bairro, Cidade, Estado),
    FOREIGN KEY (LocadorCPF) REFERENCES Locador(CPF) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Quarto (
    PropriedadeRua VARCHAR(100) NOT NULL,
    PropriedadeNumero VARCHAR(10) NOT NULL,
    PropriedadeBairro VARCHAR(100) NOT NULL,
    PropriedadeCidade VARCHAR(100) NOT NULL,
    PropriedadeEstado CHAR(2) NOT NULL,
    NumeroQuarto INT NOT NULL,
    NumeroCamas INT NOT NULL,
    BanheiroPrivativo BOOLEAN NOT NULL,
    PRIMARY KEY (PropriedadeRua, PropriedadeNumero, PropriedadeBairro, PropriedadeCidade, PropriedadeEstado, NumeroQuarto),
    FOREIGN KEY (PropriedadeRua, PropriedadeNumero, PropriedadeBairro, PropriedadeCidade, PropriedadeEstado) 
        REFERENCES Propriedade(Rua, Numero, Bairro, Cidade, Estado)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Reserva (
    NumeroReserva VARCHAR(10) PRIMARY KEY,
    DataCheckIn DATE,
    DataCheckOut DATE,
    DataReserva DATE,
    NumeroHospedes INT,
    PropriedadeRua VARCHAR(100) NOT NULL,
    PropriedadeNumero VARCHAR(10) NOT NULL,
    PropriedadeBairro VARCHAR(100) NOT NULL,
    PropriedadeCidade VARCHAR(100) NOT NULL,
    PropriedadeEstado CHAR(2) NOT NULL,
    LocatarioCPF VARCHAR(14) NOT NULL,
    Imposto DECIMAL(10, 2),
    PrecoTotal DECIMAL(10, 2),
    Confirmada BOOLEAN,
    FOREIGN KEY (PropriedadeRua, PropriedadeNumero, PropriedadeBairro, PropriedadeCidade, PropriedadeEstado) 
        REFERENCES Propriedade(Rua, Numero, Bairro, Cidade, Estado)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (LocatarioCPF) REFERENCES Locatario(CPF)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE ContaBancaria (
    NumeroConta CHAR(10) PRIMARY KEY,
    LocadorCPF VARCHAR(14) NOT NULL,
    Agencia INT NOT NULL,
    TipoConta VARCHAR(20) NOT NULL,
    FOREIGN KEY (LocadorCPF) REFERENCES Locador(CPF)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Localizacao (
    CEP VARCHAR(10) NOT NULL,
    NumeroCasa VARCHAR(10) NOT NULL,
    PropriedadeRua VARCHAR(100) NOT NULL,
    PropriedadeNumero VARCHAR(10) NOT NULL,
    PropriedadeBairro VARCHAR(100) NOT NULL,
    PropriedadeCidade VARCHAR(100) NOT NULL,
    PropriedadeEstado CHAR(2) NOT NULL,
    Pais VARCHAR(100),
    PontosDeInteresse VARCHAR(255),
    PRIMARY KEY (CEP, NumeroCasa),
    FOREIGN KEY (PropriedadeRua, PropriedadeNumero, PropriedadeBairro, PropriedadeCidade, PropriedadeEstado)
        REFERENCES Propriedade(Rua, Numero, Bairro, Cidade, Estado)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Avaliacao (
    PropriedadeRua VARCHAR(100) NOT NULL,
    PropriedadeNumero VARCHAR(10) NOT NULL,
    PropriedadeBairro VARCHAR(100) NOT NULL,
    PropriedadeCidade VARCHAR(100) NOT NULL,
    PropriedadeEstado CHAR(2) NOT NULL,
    NumeroAvaliacao INT NOT NULL,
    Mensagem TEXT,
    Fotos JSON,
    Limpeza INT,
    ClassificacaoLimpeza INT,
    LocatarioCPF CHAR(14),
    ClassificacaoEstrutura INT,
    NotasParaAnfitriao INT,
    NotasParaLocalizacao INT,
    NotasParaValor INT,
    PRIMARY KEY (PropriedadeRua, PropriedadeNumero, PropriedadeBairro, PropriedadeCidade, PropriedadeEstado, NumeroAvaliacao),
    FOREIGN KEY (PropriedadeRua, PropriedadeNumero, PropriedadeBairro, PropriedadeCidade, PropriedadeEstado)
        REFERENCES Propriedade(Rua, Numero, Bairro, Cidade, Estado)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (LocatarioCPF) REFERENCES Locatario(CPF)
        ON DELETE CASCADE
        ON UPDATE CASCADE
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
    Remetente VARCHAR(255) NOT NULL,
    Data DATE NOT NULL,
    Hora TIME NOT NULL,
    Destinatario VARCHAR(255) NOT NULL,
    LocadorCPF CHAR(14) NOT NULL,
    LocatarioCPF CHAR(14) NOT NULL,
    PRIMARY KEY (Remetente, Data, Hora, Destinatario),
    FOREIGN KEY (LocadorCPF) REFERENCES Locador(CPF)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (LocatarioCPF) REFERENCES Locatario(CPF)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Pesquisa (
    LocatarioCPF CHAR(14),
    PropriedadeRua VARCHAR(100) NOT NULL,
    PropriedadeNumero VARCHAR(10) NOT NULL,
    PropriedadeBairro VARCHAR(100) NOT NULL,
    PropriedadeCidade VARCHAR(100) NOT NULL,
    PropriedadeEstado CHAR(2) NOT NULL,
    PRIMARY KEY (LocatarioCPF, PropriedadeRua, PropriedadeNumero, PropriedadeBairro, PropriedadeCidade, PropriedadeEstado),
    FOREIGN KEY (LocatarioCPF) REFERENCES Locatario(CPF)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (PropriedadeRua, PropriedadeNumero, PropriedadeBairro, PropriedadeCidade, PropriedadeEstado)
        REFERENCES Propriedade(Rua, Numero, Bairro, Cidade, Estado)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Deposita (
    LocadorCPF CHAR(14) NOT NULL,
    LocatarioCPF CHAR(14) NOT NULL,
    Valor DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (LocadorCPF, LocatarioCPF),
    FOREIGN KEY (LocadorCPF) REFERENCES Locador(CPF)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (LocatarioCPF) REFERENCES Locatario(CPF)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

