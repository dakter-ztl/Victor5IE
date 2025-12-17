Questo progetto scolastico implementa una semplice chatroom locale composta da un server Dart autonomo (TCP Socket) e un'applicazione client sviluppata con Flutter. Il sistema permette a più utenti sulla stessa rete locale di connettersi, registrarsi con un nickname e scambiarsi messaggi.

Come funziona?

L'applicazione segue un'architettura client-server basata su socket TCP/IP. Il Server (server.dart): Si avvia per primo e si mette in ascolto sulla porta 3000. Gestisce le connessioni in entrata, registra i nickname dei client e inoltra i messaggi ricevuti a tutti gli altri partecipanti connessi (broadcast).

Il Client (App Flutter): Si connette al server tramite l'indirizzo IP e la porta specificati. Permette all'utente di inserire un nickname (che viene inviato come primo messaggio al server) e di scambiare messaggi in tempo reale. I messaggi vengono decodificati da byte a stringa e visualizzati nell'interfaccia utente.

Scelte di sviluppo dart:io ServerSocket e Socket: Scelti per implementare una comunicazione di rete a basso livello, ideale per una chatroom semplice e diretta. Flutter StatefulWidget: Utilizzati nella parte client per gestire lo stato dinamico della lista dei messaggi e del campo di input. Stream in Dart: Il flusso di dati in arrivo dai socket viene gestito tramite Stream e .listen(), un approccio efficiente per l'ascolto continuo degli eventi di rete. Gestione NicknamePage separata: Sviluppata una schermata iniziale dedicata per l'inserimento del nickname, garantendo che l'utente si registri correttamente prima di accedere alla chat principale.

Linguaggi e Tecnologie Utilizzati

Dart: Linguaggio di programmazione principale, utilizzato sia per il server backend che per l'applicazione client. Flutter: Framework UI utilizzato per costruire l'interfaccia utente multipiattaforma dell'app client.
