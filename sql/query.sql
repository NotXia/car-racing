-- Visualizzare il tempo reale per ogni giro
CREATE VIEW IF NOT EXISTS GiroReale AS
SELECT Giro.id, Giro.pilota, Giro.gara, Giro.numero, (Giro.tempo + COALESCE(SUM(Penalizza.penalita), 0) + COALESCE(Pitstop.tempo_totale, 0)) AS tempo_totale
FROM Giro LEFT OUTER JOIN Penalizza ON Giro.id = Penalizza.giro
    LEFT OUTER JOIN Pitstop ON Giro.id = Pitstop.giro
GROUP BY Giro.id, Giro.pilota, Giro.gara, Giro.numero, Giro.tempo;

SELECT * FROM GiroReale;

-- Visualizzare lo sponsor di una gara
SELECT S.*
FROM Gara AS G INNER JOIN Sponsor AS S ON G.sponsor = S.ragione_sociale
WHERE G.nome = 'Gran Premio d''Italia';

-- Visualizzare il pilota con il tempo migliore su una data pista
SELECT Pilota.nome, Pilota.cognome, GiroReale.tempo_totale
FROM GiroReale INNER JOIN Gara ON GiroReale.gara = Gara.nome
    INNER JOIN Pilota ON GiroReale.pilota = Pilota.codice_fiscale
WHERE Gara.pista = 'Autodromo Enzo e Dino Ferrari' AND
    GiroReale.tempo_totale = (
        SELECT GiroReale.tempo_totale
        FROM GiroReale INNER JOIN Gara ON GiroReale.gara = Gara.nome
            INNER JOIN Pilota ON GiroReale.pilota = Pilota.codice_fiscale
        WHERE Gara.pista = 'Autodromo Enzo e Dino Ferrari'
        ORDER BY GiroReale.tempo_totale LIMIT 1
    );

-- Visualizzare i piloti e la scuderia con cui gareggiano per una data gara ordinandoli per scuderia
SELECT D.nome, D.cognome, C.scuderia
FROM Partecipa AS P INNER JOIN Pilota AS D ON P.pilota = D.codice_fiscale
    INNER JOIN Contratto AS C ON D.codice_fiscale = C.pilota
    INNER JOIN Gara AS G ON P.gara = G.nome
WHERE P.gara = 'Azerbaijan Grand Prix' AND
    G.data_ora BETWEEN C.data_inizio AND C.data_fine
ORDER BY C.scuderia;

-- Visualizzare la classifica (finale o temporanea) di una data gara
SELECT Pilota.nome, Pilota.cognome, Contratto.scuderia, COUNT(GiroReale.numero) AS num_giri, SUM(GiroReale.tempo_totale) AS tempo_gara
FROM GiroReale INNER JOIN Pilota ON GiroReale.pilota = Pilota.codice_fiscale
    INNER JOIN Contratto ON Pilota.codice_fiscale = Contratto.pilota
    INNER JOIN Gara ON GiroReale.gara = Gara.nome
WHERE GiroReale.gara = 'Belgian Grand Prix' AND
    Gara.data_ora BETWEEN Contratto.data_inizio AND Contratto.data_fine
GROUP BY GiroReale.pilota
ORDER BY num_giri DESC, tempo_gara ASC;

-- Visualizzare i vincitori di una gara
SELECT Pilota.nome, Pilota.cognome, Contratto.scuderia
FROM GiroReale INNER JOIN Pilota ON GiroReale.pilota = Pilota.codice_fiscale
    INNER JOIN Contratto ON Pilota.codice_fiscale = Contratto.pilota
    INNER JOIN Gara ON GiroReale.gara = Gara.nome
WHERE GiroReale.gara = 'Australian Grand Prix' AND
    Gara.data_ora BETWEEN Contratto.data_inizio AND Contratto.data_fine
GROUP BY GiroReale.pilota
HAVING SUM(GiroReale.tempo_totale) = (
        SELECT SUM(GiroReale.tempo_totale) AS tempo_gara
        FROM GiroReale
        WHERE GiroReale.gara = 'Australian Grand Prix'
        GROUP BY GiroReale.pilota
        ORDER BY COUNT(GiroReale.pilota) DESC, tempo_gara ASC
    )
ORDER BY COUNT(GiroReale.pilota) DESC, SUM(GiroReale.tempo_totale) ASC;

-- Visualizzare il pilota con il maggior numero di vittorie


-- Visualizzare la scuderia con il maggior numero di vittorie


-- Visualizzare lo sponsor più presente
SELECT X.ragione_sociale, COUNT(*) AS num_comparse
FROM (SELECT S.ragione_sociale
    FROM Sponsor AS S INNER JOIN Investe AS I ON I.sponsor = S.ragione_sociale
    UNION ALL
    SELECT S.ragione_sociale
    FROM Sponsor AS S INNER JOIN Gara AS G ON S.ragione_sociale = G.sponsor) AS X
GROUP BY X.ragione_sociale
HAVING COUNT(*) = ( SELECT COUNT(*)
                    FROM (SELECT S.ragione_sociale
                    FROM Sponsor AS S INNER JOIN Investe AS I ON I.sponsor = S.ragione_sociale
                    UNION ALL
                    SELECT S.ragione_sociale
                    FROM Sponsor AS S INNER JOIN Gara AS G ON S.ragione_sociale = G.sponsor) AS X
                    GROUP BY X.ragione_sociale
                    ORDER BY COUNT(*) DESC LIMIT 1);

-- Visualizzare la scuderia con cui un pilota ha un contratto in una determinata data
SELECT C.scuderia
FROM Contratto AS C
WHERE '2023-01-27' BETWEEN C.data_inizio AND C.data_fine AND
    C.pilota = 'SCHMCK99C22Z110X';

-- Visualizzare nome, cognome e numero dei piloti di una data scuderia con contratto attivo al momento attuale 
SELECT P.cognome, P.nome, C.numero_pilota
FROM Contratto AS C INNER JOIN Scuderia AS S ON C.scuderia = S.ragione_sociale 
    INNER JOIN Pilota AS P ON P.codice_fiscale = C.pilota
WHERE S.ragione_sociale = 'Ferrari' AND
    C.data_fine >= date('now');

-- Visualizzare pilota e scuderia con il pitstop più veloce
SELECT Pilota.nome, Pilota.cognome, Contratto.scuderia, Pitstop.tempo_operazione, Gara.nome AS nome_gara
FROM Pitstop INNER JOIN Giro ON Pitstop.giro = Giro.id
    INNER JOIN Pilota ON Giro.pilota = Pilota.codice_fiscale
    INNER JOIN Gara ON Giro.gara = Gara.nome
    INNER JOIN Contratto ON Pilota.codice_fiscale = Contratto.pilota
WHERE (Gara.data_ora BETWEEN Contratto.data_inizio AND Contratto.data_fine) AND
    Pitstop.tempo_operazione = (
        SELECT Pitstop.tempo_operazione
        FROM Pitstop
        ORDER BY Pitstop.tempo_operazione LIMIT 1
    );

-- Incrementare la potenza e la velocità massima dei veicoli di una data scuderia
-- DA COMPLETARE
UPDATE Veicolo
SET potenza = potenza + 50,
    max_velocita = max_velocita + 5
WHERE Veicolo.id = (
    SELECT Veicolo.id
    FROM Veicolo INNER JOIN 
    )