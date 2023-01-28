-- Visualizzare lo sponsor di una gara
SELECT S.*
FROM Gara AS G INNER JOIN Sponsor AS S ON G.sponsor = S.ragione_sociale
WHERE G.nome = 'Gran Premio d''Italia';

-- Visualizzare il pilota con il tempo migliore su una data pista
SELECT P.nome, P.cognome, (G.tempo + COALESCE(SUM(Penalizza.penalita), 0)) AS tempo_tot
FROM Pilota AS P INNER JOIN Giro AS G ON P.codice_fiscale = G.pilota
    INNER JOIN Gara AS R ON G.gara = R.nome
    LEFT OUTER JOIN Penalizza ON G.id = Penalizza.giro
WHERE R.pista = 'Baku Street Circuit'
GROUP BY G.id, P.nome, P.cognome
ORDER BY tempo_tot LIMIT 1;

-- Visualizzare i piloti e la scuderia con cui gareggiano per una data gara ordinandoli per scuderia
SELECT D.nome, D.cognome, C.scuderia
FROM Partecipa AS P INNER JOIN Pilota AS D ON P.pilota = D.codice_fiscale
    INNER JOIN Contratto AS C ON D.codice_fiscale = C.pilota
    INNER JOIN Gara AS G ON P.gara = G.nome
WHERE P.gara = 'Azerbaijan Grand Prix' AND
    G.data_ora BETWEEN C.data_inizio AND C.data_fine
ORDER BY C.scuderia;

-- Visualizzare la classifica (finale o temporanea) di una data gara
SELECT Pilota.nome, Pilota.cognome, (SUM(Giro.tempo) + COALESCE(SUM(Penalizza.penalita), 0)) AS tempo_tot
FROM Gara INNER JOIN Giro ON Gara.nome = Giro.gara
    INNER JOIN Pilota ON Pilota.codice_fiscale = Giro.pilota
    LEFT OUTER JOIN Penalizza ON Giro.id = Penalizza.giro
WHERE Gara.nome = 'Azerbaijan Grand Prix'
GROUP BY Giro.pilota, Pilota.nome, Pilota.cognome
ORDER BY COUNT(Giro.id) DESC, tempo_tot ASC;

-- Visualizzare il pilota con il maggior numero di vittorie


-- Visualizzare la scuderia con il maggior numero di vittorie


-- Visualizzare lo sponsor più presente
SELECT X.ragione_sociale, COUNT(*)
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
    C.pilota = 'SCHMCK99C22Z110X'

-- Visualizzare nome, cognome e numero dei piloti di una data scuderia con contratto attivo al momento attuale 
SELECT P.cognome, P.nome, C.numero_pilota
FROM Contratto AS C INNER JOIN Scuderia AS S ON C.scuderia = S.ragione_sociale 
    INNER JOIN Pilota AS P ON P.codice_fiscale = C.pilota
WHERE S.ragione_sociale = 'Aston Martin' AND
    C.data_fine >= date('now');
