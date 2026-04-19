# Film Diary – Diario cinematografico personale
---

## Victor Mereuta 
## 5IE - ITIS Carlo Zuccante


**Film Diary** è un'applicazione mobile sviluppata con flutter che permette di gestire un diario cinematografico personale. L'utente può catalogare i film che ha visto, quelli che vuole vedere e quelli in corso di visione, assegnare valutazioni a stelle (1–5) e scrivere recensioni personali. I film sono organizzati per genere e filtrabili per stato.

Il backend è un servizio REST sviluppato in PHP con MySQL, che espone API complete (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`) per le risorse `genere` e `film`. L'app Flutter implementa una cache locale con SQLite (pacchetto `sqflite`) che consente la consultazione dei dati anche in assenza di connessione al server.


## Diario del progetto

Step 1 – Analisi e Setup

Definizione dell'idea progettuale: un diario cinematografico personale con due entità in relazione (Genere → Film, relazione 1:N). Setup dell'ambiente di sviluppo e creazione della struttura iniziale delle cartelle con denominazione delle classi in italiano per una maggiore chiarezza semantica.

Step 2 – Database e Schema SQL

Creazione dello schema MySQL con le tabelle genres e movies. Definizione dei vincoli e inserimento dei dati seed. La struttura riflette la logica relazionale che verrà poi mappata nei modelli Dart film.dart e genere.dart.

Step 3 – REST Server PHP

Implementazione del server REST in PHP. Classe Database con pattern Singleton per la connessione PDO e gestione delle rotte tramite index.php.

Step 4 – Flutter: Modelli e Servizi

Implementazione della logica di accesso ai dati. servizio_api.dart gestisce la comunicazione remota, mentre servizio_database.dart si occupa della persistenza locale tramite SQLite. Il file repository.dart funge da intermediario (Repository Pattern) per gestire il fallback offline.

Step 5 – Flutter: Interfaccia Utente (UI)

Sviluppo delle schermate principali:

schermata_principale.dart- dashboard dell'app.

schermata_lista_film.dart: Visualizzazione dei film tramite il widget personalizzato card_film.dart.

schermata_modulo_film.dart: Interfaccia di inserimento che integra il widget valutazione_stelle.dart.

Step 6 – Logica Offline e Rifinitura

Integrazione della logica di controllo connettività. Se il servizio_api.dart fallisce, il repository.dart interroga automaticamente il servizio_database.dart. In assenza di rete, le operazioni di scrittura vengono disabilitate per garantire la coerenza tra i database.

## Fonti

- Documentazione Flutter: https://docs.flutter.dev
- Pacchetto `sqflite`: https://pub.dev/packages/sqflite
- Pacchetto `http`: https://pub.dev/packages/http
- Pacchetto `connectivity_plus`: https://pub.dev/packages/connectivity_plus
- PHP Data Objects (PDO): https://www.php.net/manual/en/book.pdo.php
- REST API Design: https://restfulapi.net
- json-server: https://github.com/typicode/json-server
- Material Design 3: https://m3.material.io
