INSERT INTO Pista (nome, nazione, citta, lunghezza, num_posti) VALUES 
    ('Autodromo Nazionale Monza', 'Italia', 'Monza', 5793, 118865), 
    ('Baku Street Circuit', 'Azerbaijan', 'Baku', 6003, 18500);

INSERT INTO Pilota (codice_fiscale, nome, cognome, data_nascita, luogo_nascita) VALUES
    ('RSSGRG98B15Z114G', 'George', 'Russell', '1998-02-15', 'King''s Lynn'),
    ('HMLLWS85A07Z114F', 'Lewis', 'Hamilton', '1985-01-07', 'Stevenage'),
    ('VRSMXA97P30Z126X', 'Max', 'Verstappen', '1997-09-30', 'Hasselt'),
    ('PRZSRG90A26Z514G', 'Sergio', 'Pérez', '1990-01-26', 'Guadalajara'),
    ('LCLCRL97R16Z123N', 'Charles', 'Leclerc', '1997-10-16', 'Monaco'),
    ('SNZCLS94P01Z131Y', 'Carlos', 'Sainz', '1994-09-01', 'Madrid'),
    ('RCCDNL89L01Z700U', 'Daniel', 'Ricciardo', '1989-07-01', 'Perth'),
    ('NRRLND99S13Z114I', 'Lando', 'Norris', '1999-11-13', 'Bristol'),
    ('LNSFNN81L29Z131M', 'Fernando', 'Alonso', '1981-07-29', 'Oviedo'),
    ('CNOSBN96P17Z110F', 'Esteban', 'Ocon', '1996-09-17', 'Évreux'),
    ('GSLPRR96B07Z110S', 'Pierre', 'Gasly', '1996-02-07', 'Rouen'),
    ('TSNYKU00E11Z219F', 'Yuki', 'Tsunoda', '2000-05-11', 'Sagamihara'),
    ('STRLNC98R29Z401K', 'Lance', 'Stroll', '1998-10-29', 'Montréal'),
    ('VTTSST87L03Z110A', 'Sebastian', 'Vettel', '1987-07-03', 'Heppenheim'),
    ('LBNLND96C23Z241E', 'Alexander', 'Albon', '1996-03-23', 'Londra'),
    ('LTFNHL95H29Z401V', 'Nicholas', 'Latifi', '1995-06-29', 'Montréal'),
    ('BTTVTT89M28Z109S', 'Valtteri', 'Bottas', '1989-08-28', 'Nastola'),
    ('ZHOGNY99E30Z210K', 'Zhou', 'Guanyu', '1999-05-30', 'Shanghai'),
    ('MGNKVN92R05Z107H', 'Kevin', 'Magnussen', '1992-10-05', 'Roskilde'),
    ('SCHMCK99C22Z110X', 'Mick', 'Schumacher', '1999-03-22', 'Vufflens-le-Château');

INSERT INTO Scuderia (ragione_sociale, colore, nazione, anno_fondazione) VALUES
    ('Ferrari', 'Rosso', 'Italia', 1929),
    ('Red Bull', 'Blu', 'Austria', 2005),
    ('Mercedes', 'Argento', 'Germania', 2010),
    ('McLaren', 'Arancione', 'Regno Unito', 1963),
    ('Alpine', 'Blu', 'Francia', 1977),
    ('AlphaTauri', 'Blu scuro', 'Italia', 2006),
    ('Aston Martin', 'Verde', 'Regno Unito', 2019),
    ('Williams', 'Blu', 'Regno Unito', 1977),
    ('Alfa Romeo', 'Rosso scuro', 'Svizzera', 1970),
    ('Haas', 'Bianco', 'Stati Uniti', 2015);

INSERT INTO Meccanico (codice_fiscale, nome, cognome, data_nascita, luogo_nascita, ruolo, scuderia) VALUES 
    ('447-09-1101', 'Kendra', 'Beard', '1958-02-15', 'Boynton', 'Capo strategista', 'Ferrari'),
    ('107-12-3042', 'Kimberly', 'Dillon', '1981-09-04', 'New York', 'Meccanico', 'Red Bull'),
    ('606-29-2134', 'Jeanne', 'Allen', '1979-04-27', 'San Diego', 'Meccanico', 'Ferrari'),
    ('253-47-3122', 'Clara', 'Carlisle', '1968-12-08', 'Atlanta', 'Meccanico', 'Mercedes');

INSERT INTO Supervisore (codice_fiscale, nome, cognome, data_nascita, luogo_nascita) VALUES 
    ('290-42-0000', 'Regina', 'Foster', '1977-02-06', 'Westerville'),
    ('419-54-0000', 'Vincent', 'Kennedy', '1939-08-10', 'Gantt'),
    ('639-94-0000', 'Gilberto', 'Maddux', '1966-11-26', 'Keller'),
    ('158-16-0000', 'Tammy', 'Bailey', '1945-06-31', 'West Orange');

INSERT INTO Veicolo (id, nome, potenza, max_velocita) VALUES 
    (0, 'W13 E Performance', 1000, 320),
    (1, 'W13 E Performance', 1000, 320),
    (2, 'RB18', 1040, 330),
    (3, 'RB18', 1040, 330),
    (4, 'F1-75', 1035, 324),
    (5, 'F1-75', 1035, 324),
    (6, 'MCL36', 1000, 321),
    (7, 'MCL36', 1000, 321),
    (8, 'A522', 980, 318),    
    (9, 'A522', 980, 318),
    (10, 'AT03', 960, 318),    
    (11, 'AT03', 960, 318),
    (12, 'AMR22', 960, 318),    
    (13, 'AMR22', 960, 318),
    (14, 'FW44', 1000, 320),    
    (15, 'FW44', 1000, 320),
    (16, 'C42', 1000, 320),    
    (17, 'C42', 1000, 320),
    (18, 'VF-22', 1020, 322),   
    (19, 'VF-22', 1020, 322);

INSERT INTO Controllo (veicolo, data_ora, esito, supervisore) VALUES 
    (0, '2023-03-03 15:33:33', 'Positivo', '419-54-0000');

INSERT INTO Sponsor (ragione_sociale, tipologia, nazione) VALUES 
    ('Coca Cola', 'Alimentare', 'Stati Uniti'),
    ('Pirelli', 'Pneumatici', 'Italia'),
    ('Acer', 'Informatica', 'Taiwan'),
    ('Save the Children', 'ONG', 'Regno Unito'),
    ('Rolex', 'Orologeria', 'Svizzera'),
    ('Nike', 'Abbigliamento', 'Stati Uniti');

INSERT INTO Gara (nome, data_ora, num_giri, sponsor, pista) VALUES 
    ('Gran Premio d''Italia', '2022-09-18 14:00:00', 53, 'Rolex', 'Autodromo Nazionale Monza'),
    ('Azerbaijan Grand Prix', '2022-04-24 15:00:00', 51, NULL, 'Baku Street Circuit');

INSERT INTO Partecipa (gara, pilota) VALUES 
    ('Gran Premio d''Italia', 'RSSGRG98B15Z114G'),
    ('Gran Premio d''Italia', 'HMLLWS85A07Z114F'),
    ('Gran Premio d''Italia', 'VRSMXA97P30Z126X'),
    ('Gran Premio d''Italia', 'PRZSRG90A26Z514G'),
    ('Gran Premio d''Italia', 'LCLCRL97R16Z123N'),
    ('Gran Premio d''Italia', 'SNZCLS94P01Z131Y'),
    ('Gran Premio d''Italia', 'RCCDNL89L01Z700U'),
    ('Gran Premio d''Italia', 'NRRLND99S13Z114I'),
    ('Gran Premio d''Italia', 'LNSFNN81L29Z131M'),
    ('Gran Premio d''Italia', 'CNOSBN96P17Z110F'),
    ('Gran Premio d''Italia', 'GSLPRR96B07Z110S'),
    ('Gran Premio d''Italia', 'TSNYKU00E11Z219F'),
    ('Gran Premio d''Italia', 'STRLNC98R29Z401K'),
    ('Gran Premio d''Italia', 'VTTSST87L03Z110A'),
    ('Gran Premio d''Italia', 'LBNLND96C23Z241E'),
    ('Gran Premio d''Italia', 'LTFNHL95H29Z401V'),
    ('Gran Premio d''Italia', 'BTTVTT89M28Z109S'),
    ('Gran Premio d''Italia', 'ZHOGNY99E30Z210K'),
    ('Gran Premio d''Italia', 'MGNKVN92R05Z107H'),
    ('Gran Premio d''Italia', 'SCHMCK99C22Z110X'),
    ('Azerbaijan Grand Prix', 'RSSGRG98B15Z114G'),
    ('Azerbaijan Grand Prix', 'HMLLWS85A07Z114F'),
    ('Azerbaijan Grand Prix', 'VRSMXA97P30Z126X'),
    ('Azerbaijan Grand Prix', 'PRZSRG90A26Z514G'),
    ('Azerbaijan Grand Prix', 'LCLCRL97R16Z123N'),
    ('Azerbaijan Grand Prix', 'SNZCLS94P01Z131Y'),
    ('Azerbaijan Grand Prix', 'RCCDNL89L01Z700U'),
    ('Azerbaijan Grand Prix', 'NRRLND99S13Z114I'),
    ('Azerbaijan Grand Prix', 'LNSFNN81L29Z131M'),
    ('Azerbaijan Grand Prix', 'CNOSBN96P17Z110F'),
    ('Azerbaijan Grand Prix', 'GSLPRR96B07Z110S'),
    ('Azerbaijan Grand Prix', 'TSNYKU00E11Z219F'),
    ('Azerbaijan Grand Prix', 'STRLNC98R29Z401K'),
    ('Azerbaijan Grand Prix', 'VTTSST87L03Z110A'),
    ('Azerbaijan Grand Prix', 'LBNLND96C23Z241E'),
    ('Azerbaijan Grand Prix', 'LTFNHL95H29Z401V'),
    ('Azerbaijan Grand Prix', 'BTTVTT89M28Z109S'),
    ('Azerbaijan Grand Prix', 'ZHOGNY99E30Z210K'),
    ('Azerbaijan Grand Prix', 'MGNKVN92R05Z107H'),
    ('Azerbaijan Grand Prix', 'SCHMCK99C22Z110X');

INSERT INTO Investe (scuderia, sponsor) VALUES 
    ('Ferrari', 'Nike'),
    ('Ferrari', 'Pirelli'),
    ('Red Bull', 'Pirelli'),
    ('Mercedes', 'Rolex'),
    ('McLaren', 'Coca Cola'),
    ('Alpine', 'Save the Children'),
    ('AlphaTauri', 'Acer'),
    ('AlphaTauri', 'Pirelli'),
    ('Aston Martin', 'Nike'),
    ('Williams', 'Coca Cola'),
    ('Alfa Romeo', 'Nike'),
    ('Alfa Romeo', 'Pirelli'),
    ('Haas', 'Acer');

-- INSERT INTO Giro (numero, tempo, gara, pilota) VALUES 
--     ();

-- INSERT INTO Pitstop (giro, tempo_operazione, tempo_totale) VALUES 
--     ();

INSERT INTO Infrazione (nome, descrizione) VALUES 
    ('Taglio di curva', 'Quando un pilota taglia la curva'),
    ('Eccessiva velocità in pit lane', 'Quando un pilota guida con velocità eccessiva nella pit lane'),
    ('Eccessiva velocità durante safety car', 'Quando un pilota guida con velocità eccessiva durante il regime di safety car');

-- INSERT INTO Penalizza (giro, infrazione, penalita) VALUES 
--     ();

-- INSERT INTO Opera (pitstop, meccanico) VALUES 
--     ();

INSERT INTO Contratto (numero, data_inizio, data_fine, numero_pilota, pilota, scuderia, veicolo) VALUES 
    (NULL, '2022-01-01', '2023-12-31', 63, 'RSSGRG98B15Z114G', 'Mercedes',     1),
    (NULL, '2010-01-01', '2023-12-31', 44, 'HMLLWS85A07Z114F', 'Mercedes',     0),
    (NULL, '2016-01-01', '2028-12-31', 1, 'VRSMXA97P30Z126X', 'Red Bull',      2),
    (NULL, '2021-01-01', '2023-12-31', 11, 'PRZSRG90A26Z514G', 'Red Bull',     3),
    (NULL, '2019-01-01', '2024-12-31', 16, 'LCLCRL97R16Z123N', 'Ferrari',      4),
    (NULL, '2021-01-01', '2024-12-31', 55, 'SNZCLS94P01Z131Y', 'Ferrari',      5),
    (NULL, '2021-01-01', '2022-12-31', 3, 'RCCDNL89L01Z700U', 'McLaren',       7),
    (NULL, '2019-01-01', '2025-12-31', 4, 'NRRLND99S13Z114I', 'McLaren',       6),
    (NULL, '2021-01-01', '2022-12-31', 14, 'LNSFNN81L29Z131M', 'Alpine',       8),
    (NULL, '2021-01-01', '2024-12-31', 31, 'CNOSBN96P17Z110F', 'Alpine',       9),
    (NULL, '2020-01-01', '2022-12-31', 10, 'GSLPRR96B07Z110S', 'AlphaTauri',   10),
    (NULL, '2021-01-01', '2022-12-31', 22, 'TSNYKU00E11Z219F', 'AlphaTauri',   11),
    (NULL, '2021-01-01', '2028-12-31', 18, 'STRLNC98R29Z401K', 'Aston Martin', 13),
    (NULL, '2021-01-01', '2022-12-31', 5, 'VTTSST87L03Z110A', 'Aston Martin',  12),
    (NULL, '2022-01-01', '2023-12-31', 23, 'LBNLND96C23Z241E', 'Williams',     14),
    (NULL, '2020-01-01', '2022-12-31', 6, 'LTFNHL95H29Z401V', 'Williams',      15),
    (NULL, '2022-01-01', '2024-12-31', 77, 'BTTVTT89M28Z109S', 'Alfa Romeo',   16),
    (NULL, '2022-01-01', '2024-12-31', 24, 'ZHOGNY99E30Z210K', 'Alfa Romeo',   17),
    (NULL, '2022-01-01', '2023-12-31', 20, 'MGNKVN92R05Z107H', 'Haas',         18),
    (NULL, '2021-01-01', '2022-12-31', 47, 'SCHMCK99C22Z110X', 'Haas',         19);
