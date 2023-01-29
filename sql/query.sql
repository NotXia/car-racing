-- Inserire una nuova scuderia
INSERT INTO Scuderia (ragione_sociale, colore, nazione, anno_fondazione) VALUES
    ('<ragione sociale>', '<colore>', '<nazione>', <anno fondazione>);

INSERT INTO Veicolo (id, nome, potenza, max_velocita, scuderia) VALUES 
    (NULL, '<nome>', <potenza>, <velocità max>, '<ragione sociale scuderia>');


-- Inserire una nuova gara
INSERT INTO Gara (nome, data_ora, sponsor, pista) VALUES 
    ('<nome>', '<data e ora>', <sponsor o NULL>, '<nome pista>');


-- Inserire il tempo di un giro del pilota sulla pista
INSERT INTO Giro (id, numero, tempo, gara, pilota) VALUES 
    (NULL, <numero>, <tempo>, '<nome gara>', '<codice fiscale pilota>');

-- Inserire il tempo pit stop
INSERT INTO Pitstop (giro, tempo_operazione, tempo_totale) VALUES 
    (<id giro>, <tempo operazione>, <tempo totale>);


-- Inserire un nuovo contratto tra pilota e scuderia
INSERT INTO Contratto (numero, data_inizio, data_fine, numero_pilota, pilota, scuderia, veicolo) VALUES 
    (NULL, '<data inizio>', '<data fine>', <numero pilota>, '<codice fiscale pilota>', '<ragione sociale scuderia>', <id veicolo>);


-- Incrementare la potenza e la velocità massima dei veicoli di una data scuderia
UPDATE Veicolo
SET potenza = potenza + 50,
    max_velocita = max_velocita + 5
WHERE Veicolo.scuderia = 'Ferrari';


-- Visualizzare la lunghezza media, massima e minima delle piste
SELECT AVG(lunghezza), MAX(lunghezza), MIN(lunghezza)
FROM Pista;


-- Visualizzare lo sponsor di una gara
SELECT S.*
FROM Gara AS G INNER JOIN Sponsor AS S ON G.sponsor = S.ragione_sociale
WHERE G.nome = 'Gran Premio d''Italia';


-- Visualizzare lo sponsor più presente
SELECT sponsor.ragione_sociale, COUNT(*) AS num_comparse
FROM (SELECT Investe.sponsor AS ragione_sociale FROM Investe 
      UNION ALL 
      SELECT Gara.sponsor AS ragione_sociale FROM Gara) AS sponsor
GROUP BY sponsor.ragione_sociale
HAVING num_comparse = (SELECT COUNT(*) AS comparse
                       FROM (SELECT Investe.sponsor AS ragione_sociale FROM Investe 
                             UNION ALL 
                             SELECT Gara.sponsor AS ragione_sociale FROM Gara) AS sponsor
                       GROUP BY sponsor.ragione_sociale
                       ORDER BY comparse DESC LIMIT 1);


-- Visualizzare la scuderia con cui un pilota ha un contratto in una determinata data
SELECT C.scuderia
FROM Contratto AS C
WHERE ('2023-01-27' BETWEEN C.data_inizio AND C.data_fine) AND
    C.pilota = 'SCHMCK99C22Z110X';


-- Visualizzare nome, cognome e numero di gara dei piloti di una data scuderia con contratto attivo al momento attuale 
SELECT P.cognome, P.nome, C.numero_pilota
FROM Contratto AS C INNER JOIN Scuderia AS S ON C.scuderia = S.ragione_sociale 
    INNER JOIN Pilota AS P ON P.codice_fiscale = C.pilota
WHERE S.ragione_sociale = 'Ferrari' AND
    (date('now') BETWEEN C.data_inizio AND C.data_fine);


-- Visualizzare i piloti e la scuderia con cui gareggiano per una data gara raggruppandoli per scuderia
SELECT D.nome, D.cognome, C.scuderia
FROM Partecipa AS P INNER JOIN Pilota AS D ON P.pilota = D.codice_fiscale
    INNER JOIN Contratto AS C ON D.codice_fiscale = C.pilota
    INNER JOIN Gara AS G ON P.gara = G.nome
WHERE P.gara = 'Azerbaijan Grand Prix' AND
    (G.data_ora BETWEEN C.data_inizio AND C.data_fine)
ORDER BY C.scuderia;


-- Visualizzare il tempo reale per ogni giro
CREATE VIEW IF NOT EXISTS GiroReale AS
SELECT Giro.id, Giro.pilota, Giro.gara, Giro.numero, (Giro.tempo + COALESCE(SUM(Penalizza.penalita), 0) + COALESCE(Pitstop.tempo_totale, 0)) AS tempo_totale
FROM Giro LEFT OUTER JOIN Penalizza ON Giro.id = Penalizza.giro
    LEFT OUTER JOIN Pitstop ON Giro.id = Pitstop.giro
GROUP BY Giro.id, Giro.pilota, Giro.gara, Giro.numero;

SELECT * FROM GiroReale;


-- Visualizzare il pilota con il tempo migliore su una data pista
SELECT Pilota.nome, Pilota.cognome, GiroReale.tempo_totale
FROM GiroReale INNER JOIN Gara ON GiroReale.gara = Gara.nome
    INNER JOIN Pilota ON GiroReale.pilota = Pilota.codice_fiscale
WHERE Gara.pista = 'Autodromo Enzo e Dino Ferrari' AND
    GiroReale.tempo_totale = (
        SELECT MIN(GiroReale.tempo_totale)
        FROM GiroReale INNER JOIN Gara ON GiroReale.gara = Gara.nome
        WHERE Gara.pista = 'Autodromo Enzo e Dino Ferrari'
    );


-- Visualizzare la classifica (finale o temporanea) di una data gara
SELECT Pilota.nome, Pilota.cognome, Contratto.scuderia, COUNT(GiroReale.id) AS num_giri, SUM(GiroReale.tempo_totale) AS tempo_gara
FROM GiroReale INNER JOIN Pilota ON GiroReale.pilota = Pilota.codice_fiscale
    INNER JOIN Contratto ON Pilota.codice_fiscale = Contratto.pilota
    INNER JOIN Gara ON GiroReale.gara = Gara.nome
WHERE GiroReale.gara = 'Australian Grand Prix' AND
    (Gara.data_ora BETWEEN Contratto.data_inizio AND Contratto.data_fine)
GROUP BY GiroReale.pilota, Pilota.nome, Pilota.cognome, Contratto.scuderia
ORDER BY num_giri DESC, tempo_gara ASC;


-- Visualizzare i vincitori di una gara
SELECT Pilota.nome, Pilota.cognome, Contratto.scuderia
FROM GiroReale INNER JOIN Pilota ON GiroReale.pilota = Pilota.codice_fiscale
    INNER JOIN Contratto ON Pilota.codice_fiscale = Contratto.pilota
    INNER JOIN Gara ON GiroReale.gara = Gara.nome
    INNER JOIN Pista ON Gara.pista = Pista.nome
WHERE GiroReale.gara = 'Australian Grand Prix' AND
    (Gara.data_ora BETWEEN Contratto.data_inizio AND Contratto.data_fine)
GROUP BY GiroReale.pilota, Pilota.nome, Pilota.cognome, Contratto.scuderia
HAVING SUM(GiroReale.tempo_totale) = (
        SELECT SUM(GiroReale.tempo_totale) AS tempo_gara
        FROM GiroReale
        WHERE GiroReale.gara = 'Australian Grand Prix'
        GROUP BY GiroReale.pilota
        ORDER BY COUNT(GiroReale.id) DESC, tempo_gara ASC LIMIT 1
    ) AND
    COUNT(GiroReale.id) = Pista.num_giri
ORDER BY COUNT(GiroReale.id) DESC, SUM(GiroReale.tempo_totale) ASC;


-- Visualizzare in ordine decrescente i piloti e il loro numero di vittorie
CREATE VIEW IF NOT EXISTS Vincitore AS
SELECT Pilota.nome, Pilota.cognome, Pilota.codice_fiscale, COUNT(vincitori.gara) AS vittorie
FROM Pilota LEFT OUTER JOIN (SELECT GiroReale.pilota, GiroReale.gara
                        FROM GiroReale INNER JOIN Gara ON GiroReale.gara = Gara.nome
                                       INNER JOIN Pista ON Gara.pista = Pista.nome
                        GROUP BY GiroReale.gara, GiroReale.pilota
                        HAVING SUM(GiroReale.tempo_totale) = (
                                SELECT SUM(GR.tempo_totale)
                                FROM GiroReale AS GR
                                WHERE GR.gara = GiroReale.gara
                                GROUP BY GR.pilota
                                ORDER BY COUNT(GR.id) DESC, SUM(GR.tempo_totale) ASC LIMIT 1
                            ) AND
                            COUNT(GiroReale.id) = Pista.num_giri
    ) AS vincitori ON Pilota.codice_fiscale = vincitori.pilota
GROUP BY Pilota.codice_fiscale
ORDER BY vittorie DESC;

SELECT * FROM Vincitore;


-- Visualizzare il pilota più giovane ad aver vinto almeno una gara
SELECT Pilota.nome, Pilota.cognome, Pilota.data_nascita
FROM Vincitore INNER JOIN Pilota ON Vincitore.codice_fiscale = Pilota.codice_fiscale
WHERE Vincitore.vittorie > 0 AND
    Pilota.data_nascita = (
    SELECT MAX(Pilota.data_nascita)
    FROM Vincitore INNER JOIN Pilota ON Vincitore.codice_fiscale = Pilota.codice_fiscale
    WHERE Vincitore.vittorie > 0
    );


-- Visualizzare pilota e scuderia con il pitstop più veloce
SELECT Pilota.nome, Pilota.cognome, Contratto.scuderia, Pitstop.tempo_operazione, Gara.nome AS nome_gara
FROM Pitstop INNER JOIN Giro ON Pitstop.giro = Giro.id
    INNER JOIN Pilota ON Giro.pilota = Pilota.codice_fiscale
    INNER JOIN Gara ON Giro.gara = Gara.nome
    INNER JOIN Contratto ON Pilota.codice_fiscale = Contratto.pilota
WHERE (Gara.data_ora BETWEEN Contratto.data_inizio AND Contratto.data_fine) AND
    Pitstop.tempo_operazione = (
        SELECT MIN(Pitstop.tempo_operazione)
        FROM Pitstop
    );
    

-- Visualizzare il supervisore che ha effettuato il maggior numero di controlli con esito negativo
SELECT Supervisore.nome, Supervisore.cognome, Supervisore.codice_fiscale
FROM Supervisore INNER JOIN Controllo ON Supervisore.codice_fiscale = Controllo.supervisore
WHERE Controllo.esito = 0
GROUP BY Controllo.supervisore, Supervisore.nome, Supervisore.cognome, Supervisore.codice_fiscale
HAVING COUNT(*) = (
    SELECT COUNT(*)
    FROM Controllo
    WHERE Controllo.esito = 0
    GROUP BY Controllo.supervisore
    ORDER BY COUNT(*) DESC LIMIT 1
);

-- Visualizzare la scuderia e l'auto che ha avuto il maggior numero di controlli con esito negativo
SELECT Veicolo.nome, Veicolo.scuderia
FROM Veicolo INNER JOIN Controllo ON Veicolo.id = Controllo.veicolo
WHERE Controllo.esito = 0
GROUP BY Controllo.veicolo, Veicolo.nome, Veicolo.scuderia
HAVING COUNT(*) = (
    SELECT COUNT(*)
    FROM Controllo
    WHERE Controllo.esito = 0
    GROUP BY Controllo.veicolo
    ORDER BY COUNT(*) DESC LIMIT 1
);