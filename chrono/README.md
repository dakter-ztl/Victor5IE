Chrono 
Deadline: 23:59 02/11/2025

Chrono è un semplice cronometro (stopwatch) realizzato con Flutter/Dart che sfrutta gli Stream per aggiornare l’interfaccia in tempo reale.
Caratteristiche principali

Aggiornamento continuo del tempo tramite un ticker stream.
Visualizzazione del tempo in minuti e secondi in modo chiaro e leggibile.
Due Floating Action Button (FAB) per il controllo completo del cronometro:
Primo bottone: cicla tra i valori di stato START, STOP e RESET.
Secondo bottone: cicla tra i valori di stato PAUSE e RESUME.
Gestione accurata della correlazione tra i due stream (ticker e secondi) per mantenere la sincronizzazione del cronometro.
Funzionamento tecnico

Ticker Stream
All’avvio dell’app, un ticker genera eventi a intervalli regolari (ogni frazione di secondo).
Ogni evento viene chiamato tuck (il tipo del valore è definito dal progettista).

Stream dei secondi
Un altro stream riceve gli eventi del ticker.
Genera un nuovo valore ogni secondo, rappresentando i secondi trascorsi.
Questo stream alimenta l’interfaccia utente, mostrando minuti e secondi in formato leggibile.

Correlazione tra stream
Lo stream dei secondi si basa sul ticker: in pratica c’è un pipe tra ticker e secondi.
Questo garantisce precisione e sincronizzazione tra l’aggiornamento continuo e la visualizzazione.
Interfaccia utente
Visualizzazione principale: minuti e secondi (frazione di minuto in secondi).

Controlli in basso a destra:
FAB 1: START → STOP → RESET
FAB 2: PAUSE → RESUME
