# zKeep

Applicazione mobile sviluppata con Flutter per la gestione di note e promemoria. Ogni nota puo contenere una lista di attivita spuntabili, permettendo di organizzare le cose da fare in modo semplice e rapido. I dati vengono salvati localmente sul dispositivo tramite un database SQLite.

Il progetto e stato realizzato nell'ambito della materia TPSIT durante l'anno scolastico 2025/2026.

---

## Funzionalita

- Creazione, visualizzazione ed eliminazione di note con titolo e descrizione
- Aggiunta, modifica, spunta ed eliminazione di promemoria all'interno di ogni nota
- Persistenza locale dei dati tramite SQLite
- Eliminazione a cascata dei promemoria alla rimozione della nota genitore

### Descrizione dei file

**model.dart**

Contiene le due classi principali dell'applicazione. `Note` rappresenta una nota con id, titolo e descrizione. `Todo` rappresenta un singolo promemoria collegato a una nota tramite chiave esterna, con un campo booleano per lo stato di completamento. Entrambe le classi espongono i metodi `toMap` e `fromMap` per la serializzazione con SQLite.

**helper.dart**

Gestisce l'inizializzazione e tutte le operazioni sul database. Al primo avvio crea le tabelle `notes` e `todos` con i vincoli necessari, incluso il `FOREIGN KEY` con `ON DELETE CASCADE`. Espone metodi statici per le operazioni CRUD su entrambe le tabelle.

**widgets.dart**

Definisce due widget stateless riutilizzabili. `NoteCard` mostra una nota nella lista principale con titolo, descrizione e pulsante di eliminazione. `TodoItem` rappresenta un singolo promemoria con checkbox, testo barrato se completato, e azioni di modifica ed eliminazione.

**main.dart**

Contiene le due schermate principali. `NotesPage` mostra la lista delle note e permette di aggiungerne di nuove tramite un dialog. `TodoPage` mostra i promemoria di una nota specifica e permette di aggiungerne, modificarli e spuntarli.

---

