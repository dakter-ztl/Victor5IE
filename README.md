<<<<<<< HEAD
# inferior_mind

# Inferior Mind

**Sviluppatore:** Victor Mereuta

## Descrizione del progetto

Inferior Mind è una versione semplificata del classico gioco da tavolo Mastermind, sviluppata in Flutter. Il giocatore deve indovinare una sequenza segreta di 4 colori generata casualmente dall'applicazione.

## Come funziona

1. L'applicazione genera un codice segreto di 4 colori all'avvio
2. Il giocatore utilizza 4 bottoni circolari per selezionare la propria sequenza
3. Premendo ripetutamente un bottone, questo cicla tra i colori disponibili
4. Quando tutti i bottoni sono colorati, il giocatore preme il Floating Action Button per verificare
5. L'app confronta la sequenza del giocatore con il codice segreto
6. Se il codice è corretto, appare un messaggio di vittoria

## Scelte di sviluppo

- **StatefulWidget:** Utilizzato per gestire lo stato dei colori selezionati e del codice segreto, permettendo l'aggiornamento dinamico dell'interfaccia

- **List<Color>:** Scelta per memorizzare sia il codice segreto che la selezione del giocatore, garantendo facilità di confronto e gestione

- **Random class:** Impiegata per generare il codice segreto casuale ad ogni nuova partita

- **Bottoni circolari:** Design minimalista con ElevatedButton a forma circolare per una migliore esperienza utente

- **Ciclo dei colori:** Implementato un sistema di rotazione ciclica tra i colori disponibili per semplicità d'uso

- **Floating Action Button:** Posizionato in basso per verificare la giocata, separando l'azione di selezione da quella di controllo

- **Reset automatico:** Dopo ogni verifica i bottoni tornano grigi, permettendo una nuova selezione immediata

- **Dialog di vittoria:** Mostra un messaggio congratulatorio e permette di iniziare una nuova partita

- **Feedback visivo:** Messaggi di stato che guidano il giocatore durante l'esperienza di gioco

- **Legenda colori:** Visualizzazione dei colori disponibili per aiutare il giocatore nella selezione

## Tecnologie utilizzate

- **Flutter** - Framework per lo sviluppo cross-platform
- **Dart** - Linguaggio di programmazione

## Come eseguire il progetto


=======
# Victor_5IE
Materiali utilizzati per la 5IE
>>>>>>> 8918b23b2cbc53e16ffd3a1cf421f4a9d88afea4
