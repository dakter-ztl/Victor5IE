
CREATE DATABASE IF NOT EXISTS filmdiary;
USE filmdiary;

CREATE TABLE IF NOT EXISTS generi (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL,
    colore     VARCHAR(7)   NOT NULL DEFAULT '#607D8B',
    creato_il  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS film (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    titolo         VARCHAR(255) NOT NULL,
    anno           SMALLINT,
    regista        VARCHAR(255),
    genere_id      INT,
    url_locandina  VARCHAR(500),
    stato          ENUM('da_vedere','in_corso','visto') NOT NULL DEFAULT 'da_vedere',
    valutazione    TINYINT CHECK (valutazione BETWEEN 1 AND 5),
    recensione     TEXT,
    creato_il      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    aggiornato_il  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_film_genere
        FOREIGN KEY (genere_id) REFERENCES generi(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- dump con dati random
INSERT INTO generi (nome, colore) VALUES
    ('Azione',       '#F44336'),
    ('Commedia',     '#FF9800'),
    ('Dramma',       '#9C27B0'),
    ('Horror',       '#212121'),
    ('Fantascienza', '#2196F3'),
    ('Animazione',   '#4CAF50'),
    ('Romantico',    '#E91E63'),
    ('Documentario', '#3F51B5'),
    ('Avventura',    '#009688'),
    ('Fantasy',      '#673AB7'),
    ('Giallo',       '#FFEB3B'),
    ('Biografico',   '#795548'),
    ('Storico',      '#607D8B'),
    ('Musicale',     '#9E9E9E'),
    ('Western',      '#FF5722'),
    ('Thriller',     '#795548');

INSERT INTO film (titolo, anno, regista, genere_id, stato, valutazione, recensione) VALUES
    ('Il Padrino',      1972, 'Francis Ford Coppola', 3, 'visto',     5, 'Un capolavoro senza tempo.'),
    ('Interstellar',    2014, 'Christopher Nolan',    5, 'visto',     5, 'Visivamente spettacolare.'),
    ('Oppenheimer',     2023, 'Christopher Nolan',    3, 'da_vedere', NULL, NULL),
    ('Parasite',        2019, 'Bong Joon-ho',         7, 'visto',     5, 'Thriller sociale perfetto.'),
    ('Dune',            2021, 'Denis Villeneuve',     5, 'in_corso',  NULL, NULL),
    ('La La Land',      2016, 'Damien Chazelle',      7, 'visto',     4, 'Musical moderno con cuore.'),
    ('Inception',       2010, 'Christopher Nolan',    5, 'visto',     5, 'Un viaggio onirico indimenticabile.'),
    ('La Vita è Bella', 1997, 'Roberto Benigni',      3, 'visto',     4, 'Commovente e poetico.');
