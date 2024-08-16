CREATE TABLE jogadores (
    id SERIAL PRIMARY KEY,
    Players VARCHAR(255),
    Teams VARCHAR(255),
    Matches INT,
    Goals INT,
    Assists INT,
    Ratings DOUBLE PRECISION
);

COPY jogadores (Players, Teams, Matches, Goals, Assists, 
	Ratings) 
	FROM 'C:/Users/leona/Desktop/trabalho de banco de dados/jogadores.csv' 
	DELIMITER ',' 
	CSV HEADER;

SELECT Players, Teams, Goals
FROM jogadores
ORDER BY Goals DESC
LIMIT 10;

SELECT Teams, 
AVG(Goals) 
FROM jogadores 
GROUP BY Teams;

SELECT Teams, 
AVG(Matches) 
FROM jogadores 
GROUP BY Teams 
HAVING AVG(Matches) > 30;

SELECT Players, Teams, Goals, Assists
FROM jogadores
WHERE Goals > 20 AND Assists > 10;

SELECT Players 
FROM jogadores 
WHERE Teams IN (SELECT Teams FROM jogadores WHERE Ratings > 8.0);

SELECT DISTINCT Teams FROM jogadores;

SELECT COUNT(*), 
AVG(Matches) 
FROM jogadores;

SELECT Players, Assists 
FROM jogadores 
ORDER BY Assists 
DESC LIMIT 10;

CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    Teams VARCHAR(255),
    Matches INT,
    Goals INT);

COPY teams (Teams, Matches, Goals) 
	FROM 'C:/Users/leona/Desktop/trabalho de banco de dados/times.csv' 
	DELIMITER ',' 
	CSV HEADER;

CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    Players VARCHAR(255),
    Matches INT,
    Goals INT,
	Assists INT,
	Ratings DOUBLE PRECISION);

COPY players (Players, Matches, Goals, Assists, Ratings) 
	FROM 'C:/Users/leona/Desktop/trabalho de banco de dados/players.csv' 
	DELIMITER ',' 
	CSV HEADER;