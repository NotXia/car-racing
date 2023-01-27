DROP TABLE IF EXISTS Pilota;
DROP TABLE IF EXISTS Meccanico;
DROP TABLE IF EXISTS Supervisore;
DROP TABLE IF EXISTS Scuderia;
DROP TABLE IF EXISTS Sponsor;
DROP TABLE IF EXISTS Contratto;
DROP TABLE IF EXISTS Veicolo;
DROP TABLE IF EXISTS Controllo;
DROP TABLE IF EXISTS Gara;
DROP TABLE IF EXISTS Pista;
DROP TABLE IF EXISTS Giro;
DROP TABLE IF EXISTS Infrazione;
DROP TABLE IF EXISTS Pitstop;
DROP TABLE IF EXISTS Partecipa;
DROP TABLE IF EXISTS Investe;
DROP TABLE IF EXISTS Penalizza;
DROP TABLE IF EXISTS Opera;

CREATE TABLE Pilota(
    codice_fiscale CHAR(50) PRIMARY KEY,
    nome CHAR(50) NOT NULL,
    cognome CHAR(50) NOT NULL,
    data_nascita DATE NOT NULL,
    luogo_nascita CHAR(50) NOT NULL
);

CREATE TABLE Meccanico(
    codice_fiscale CHAR(50) PRIMARY KEY,
    nome CHAR(50) NOT NULL,
    cognome CHAR(50) NOT NULL,
    data_nascita DATE NOT NULL,
    luogo_nascita CHAR(50) NOT NULL,
    ruolo CHAR(50) NOT NULL,
    scuderia CHAR(50) NOT NULL REFERENCES Scuderia(ragione_sociale)
);

CREATE TABLE Supervisore(
    codice_fiscale CHAR(50) PRIMARY KEY,
    nome CHAR(50) NOT NULL,
    cognome CHAR(50) NOT NULL,
    data_nascita DATE NOT NULL,
    luogo_nascita CHAR(50) NOT NULL
);

CREATE TABLE Scuderia(
    ragione_sociale CHAR(50) PRIMARY KEY,
    colore CHAR(50) NOT NULL,
    nazione CHAR(50) NOT NULL,
    anno_fondazione SMALLINT NOT NULL,
    CHECK (anno_fondazione > 0)
);

CREATE TABLE Sponsor(
    ragione_sociale CHAR(50) PRIMARY KEY,
    tipologia CHAR(50) NOT NULL,
    nazione CHAR(50) NOT NULL
);

CREATE TABLE Contratto(
    numero INTEGER PRIMARY KEY AUTOINCREMENT,
    data_inizio DATETIME NOT NULL,
    data_fine DATETIME NOT NULL,
    numero_pilota TINYINT NOT NULL,
    pilota CHAR(50) REFERENCES Pilota(codice_fiscale),
    scuderia CHAR(50) REFERENCES Scuderia(ragione_sociale),
    veicolo INTEGER REFERENCES Veicolo(id),
    CHECK (data_fine > data_inizio)
);

CREATE TABLE Veicolo(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome CHAR(50) NOT NULL,
    potenza INTEGER NOT NULL,
    max_velocita INTEGER NOT NULL,
    CHECK (potenza > 0 AND max_velocita > 0)
);

CREATE TABLE Controllo(
    veicolo INTEGER REFERENCES Veicolo(id),
    data_ora DATETIME,
    esito CHAR(50) NOT NULL,
    supervisore CHAR(50) REFERENCES Supervisore(codice_fiscale),
    PRIMARY KEY (veicolo, data_ora)
);

CREATE TABLE Gara(
    nome CHAR(50) PRIMARY KEY,
    data_ora DATETIME NOT NULL,
    num_giri TINYINT NOT NULL,
    sponsor CHAR(50) REFERENCES Sponsor(ragione_sociale),
    pista CHAR(50) REFERENCES Pista(nome),
    CHECK (num_giri > 0)
);

CREATE TABLE Pista(
    nome CHAR(50) PRIMARY KEY,
    nazione CHAR(50) NOT NULL,
    citta CHAR(50) NOT NULL,
    lunghezza INTEGER NOT NULL,
    num_posti INTEGER NOT NULL,
    CHECK (lunghezza > 0 AND num_posti >= 0)
);

CREATE TABLE Giro(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero INTEGER NOT NULL,
    tempo INTEGER NOT NULL,
    gara CHAR(50) REFERENCES Gara(nome),
    pilota CHAR(50) REFERENCES Pilota(codice_fiscale),
    CHECK (numero > 0 AND tempo > 0)
);

CREATE TABLE Infrazione(
    nome CHAR(50) PRIMARY KEY,
    descrizione CHAR(500) NOT NULL
);

CREATE TABLE Pitstop(
    giro INTEGER PRIMARY KEY REFERENCES Giro(id),
    tempo_operazione INTEGER NOT NULL,
    tempo_totale INTEGER NOT NULL,
    CHECK (tempo_operazione > 0 AND tempo_totale > tempo_operazione)
);

CREATE TABLE Partecipa(
    gara CHAR(50) REFERENCES Gara(nome),
    pilota CHAR(50) REFERENCES Pilota(codice_fiscale),
    PRIMARY KEY (gara, pilota)
);

CREATE TABLE Investe(
    sponsor CHAR(50) REFERENCES Sponsor(ragione_sociale),
    scuderia CHAR(50) REFERENCES Scuderia(ragione_sociale),
    PRIMARY KEY (sponsor, scuderia)
);

CREATE TABLE Penalizza(
    giro INTEGER REFERENCES Giro(id),
    infrazione CHAR(50) REFERENCES Infrazione(nome),
    penalita INTEGER NOT NULL,
    PRIMARY KEY (giro, infrazione),
    CHECK (penalita > 0)
);

CREATE TABLE Opera(
    pitstop INTEGER PRIMARY KEY REFERENCES Pitstop(giro),
    meccanico CHAR(50) REFERENCES Meccanico(codice_fiscale)
);