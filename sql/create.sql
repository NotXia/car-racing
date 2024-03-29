DROP TABLE IF EXISTS Contratto;
DROP TABLE IF EXISTS Controllo;
DROP TABLE IF EXISTS Supervisore;
DROP TABLE IF EXISTS Veicolo;
DROP TABLE IF EXISTS Penalizza;
DROP TABLE IF EXISTS Infrazione;
DROP TABLE IF EXISTS Partecipa;
DROP TABLE IF EXISTS Opera;
DROP TABLE IF EXISTS Investe;
DROP TABLE IF EXISTS Pitstop;
DROP TABLE IF EXISTS Giro;
DROP TABLE IF EXISTS Meccanico;
DROP TABLE IF EXISTS Pilota;
DROP TABLE IF EXISTS Gara;
DROP TABLE IF EXISTS Pista;
DROP TABLE IF EXISTS Sponsor;
DROP TABLE IF EXISTS Scuderia;

CREATE TABLE Pilota(
    codice_fiscale CHAR(20) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    data_nascita DATE NOT NULL,
    luogo_nascita VARCHAR(100) NOT NULL
);

CREATE TABLE Meccanico(
    codice_fiscale CHAR(20) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    data_nascita DATE NOT NULL,
    luogo_nascita VARCHAR(100) NOT NULL,
    ruolo VARCHAR(100) NOT NULL,
    scuderia VARCHAR(100) NOT NULL REFERENCES Scuderia(ragione_sociale) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Supervisore(
    codice_fiscale CHAR(20) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    data_nascita DATE NOT NULL,
    luogo_nascita VARCHAR(100) NOT NULL
);

CREATE TABLE Scuderia(
    ragione_sociale VARCHAR(100) PRIMARY KEY,
    colore VARCHAR(100) NOT NULL,
    nazione VARCHAR(100) NOT NULL,
    anno_fondazione SMALLINT NOT NULL,
    CHECK (anno_fondazione > 0)
);

CREATE TABLE Sponsor(
    ragione_sociale VARCHAR(100) PRIMARY KEY,
    tipologia VARCHAR(100) NOT NULL,
    nazione VARCHAR(100) NOT NULL
);

CREATE TABLE Contratto(
    numero INTEGER PRIMARY KEY AUTOINCREMENT,
    data_inizio DATETIME NOT NULL,
    data_fine DATETIME NOT NULL,
    numero_pilota TINYINT NOT NULL,
    pilota VARCHAR(100) REFERENCES Pilota(codice_fiscale) ON DELETE RESTRICT ON UPDATE CASCADE,
    scuderia VARCHAR(100) REFERENCES Scuderia(ragione_sociale) ON DELETE RESTRICT ON UPDATE CASCADE,
    veicolo INTEGER REFERENCES Veicolo(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (data_fine > data_inizio AND numero_pilota > 0)
);

CREATE TABLE Veicolo(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    potenza INTEGER NOT NULL,
    max_velocita INTEGER NOT NULL,
    scuderia VARCHAR(100) REFERENCES Scuderia(ragione_sociale) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (potenza > 0 AND max_velocita > 0)
);

CREATE TABLE Controllo(
    veicolo INTEGER REFERENCES Veicolo(id),
    data_ora DATETIME,
    esito BOOLEAN NOT NULL,
    supervisore VARCHAR(100) REFERENCES Supervisore(codice_fiscale) ON DELETE SET NULL ON UPDATE CASCADE,
    PRIMARY KEY (veicolo, data_ora)
);

CREATE TABLE Gara(
    nome VARCHAR(100) PRIMARY KEY,
    data_ora DATETIME NOT NULL,
    sponsor VARCHAR(100) REFERENCES Sponsor(ragione_sociale) ON DELETE RESTRICT ON UPDATE CASCADE,
    pista VARCHAR(100) REFERENCES Pista(nome) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Pista(
    nome VARCHAR(100) PRIMARY KEY,
    nazione VARCHAR(100) NOT NULL,
    citta VARCHAR(100) NOT NULL,
    lunghezza INTEGER NOT NULL,
    num_posti INTEGER NOT NULL,
    num_giri TINYINT NOT NULL,
    CHECK (lunghezza > 0 AND num_posti >= 0 AND num_giri > 0)
);

CREATE TABLE Giro(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero INTEGER NOT NULL,
    tempo INTEGER NOT NULL,
    gara VARCHAR(100) REFERENCES Gara(nome) ON DELETE RESTRICT ON UPDATE CASCADE,
    pilota VARCHAR(100) REFERENCES Pilota(codice_fiscale) ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (numero > 0 AND tempo > 0)
);

CREATE TABLE Infrazione(
    nome VARCHAR(100) PRIMARY KEY,
    descrizione VARCHAR(500) NOT NULL
);

CREATE TABLE Pitstop(
    giro INTEGER PRIMARY KEY REFERENCES Giro(id) ON DELETE CASCADE ON UPDATE CASCADE,
    tempo_operazione INTEGER NOT NULL,
    tempo_totale INTEGER NOT NULL,
    CHECK (tempo_operazione > 0 AND tempo_totale > tempo_operazione)
);

CREATE TABLE Partecipa(
    gara VARCHAR(100) REFERENCES Gara(nome) ON DELETE CASCADE ON UPDATE CASCADE,
    pilota VARCHAR(100) REFERENCES Pilota(codice_fiscale) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (gara, pilota)
);

CREATE TABLE Investe(
    sponsor VARCHAR(100) REFERENCES Sponsor(ragione_sociale) ON DELETE CASCADE ON UPDATE CASCADE,
    scuderia VARCHAR(100) REFERENCES Scuderia(ragione_sociale) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (sponsor, scuderia)
);

CREATE TABLE Penalizza(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    giro INTEGER REFERENCES Giro(id) ON DELETE CASCADE ON UPDATE CASCADE,
    infrazione VARCHAR(100) REFERENCES Infrazione(nome) ON DELETE RESTRICT ON UPDATE CASCADE,
    penalita INTEGER NOT NULL,
    CHECK (penalita > 0)
);

CREATE TABLE Opera(
    pitstop INTEGER REFERENCES Pitstop(giro) ON DELETE CASCADE ON UPDATE CASCADE,
    meccanico VARCHAR(100) REFERENCES Meccanico(codice_fiscale) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (pitstop, meccanico)
);