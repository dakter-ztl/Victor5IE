
**Sviluppatore:** Victor Mereuta
**ITIS Carlo Zuccante - 5IE**



Film Diary è un'applicazione mobile sviluppata con **Flutter** che permette di gestire un diario cinematografico personale. L'utente può catalogare i film che ha visto, quelli che vuole vedere e quelli in corso di visione, assegnare valutazioni a stelle (1–5) e scrivere recensioni personali. I film sono organizzati per genere e filtrabili per stato.

Il backend utilizza **json-server**, un server REST leggero basato su un semplice file JSON. L'app Flutter implementa una **cache locale con SQLite** (pacchetto `sqflite`) che consente la consultazione dei dati anche in assenza di connessione al server.
---

## Diario di Progetto

### Step 1 – Analisi e Setup

Definizione dell'idea progettuale: un diario cinematografico personale con due entità in relazione (`Genere` → `Film`, relazione 1:N). Scelta di json-server per la semplicità e la velocità di setup. Configurazione dell'ambiente di sviluppo (Flutter SDK, Node.js, VS Code).

**Motivazione:** json-server offre un server REST completamente funzionante basato su un file JSON, eliminando la necessità di configurare MySQL e PHP. Ideale per sviluppo, testing e demo. 

---

### Step 2 – Database JSON e Dati di Esempio

Creazione del file `db.json` con struttura per generi e film. Inserimento di dati di esempio coerenti con uno schema logico semplice e completo.

---

### Step 3 – Setup di json-server

Installazione di Node.js e json-server. Avvio e test del server con il file `db.json`. Documentazione delle istruzioni di avvio per emulatore, dispositivo fisico e Termux.

**Motivazione:** json-server avvia in pochi secondi su qualsiasi piattaforma e supporta automaticamente tutti i metodi HTTP (GET, POST, PUT, PATCH, DELETE) su ogni endpoint, senza scrivere codice lato server.

---

### Step 4 – Flutter: Modelli e Servizi

Creazione dei modelli `Film` e `Genere` con serializzazione JSON. Implementazione di `ServizioApi` con chiamate HTTP dirette a json-server. `ServizioDatabase` per la cache SQLite con upsert e query. `Repository` come orchestratore che tenta l'API e fallback sulla cache.

---

### Step 5 – Flutter: Interfaccia Utente

Realizzazione delle quattro schermate: `SchermataPrincipale` con statistiche, `SchermataListaFilm` con filtri per stato e genere, `SchermataModuloFilm` per la creazione e modifica dei film, `SchermataGeneri` per la gestione CRUD dei generi. Widget riutilizzabili `CardFilm` e `ValutazioneStelle`.

---

### Step 6 – Logica Offline e Resilienza

Implementazione del banner arancione in `SchermataPrincipale` quando il server non è raggiungibile. Letture fallback sulla cache SQLite. Scritture inibite offline con messaggio informativo all'utente. La cache si aggiorna automaticamente quando le richieste hanno successo.

**Motivazione:** Evita inconsistenze tra cache e server. Le scritture offline vengono inibite, non accodate, per garantire coerenza dei dati.


## Fonti

- Documentazione Flutter: https://docs.flutter.dev
- Pacchetto `sqflite`: https://pub.dev/packages/sqflite
- Pacchetto `http`: https://pub.dev/packages/http
- json-server: https://github.com/typicode/json-server
- Node.js: https://nodejs.org
- Material Design 3: https://m3.material.io
- Termux Wiki: https://wiki.termux.com