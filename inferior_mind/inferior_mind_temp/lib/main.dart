import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

// Widget principale dell'applicazione (senza stato)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inferior Mind',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Inferior Mind'),
    );
  }
}

// Widget della pagina principale (con stato perché cambia durante il gioco)
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Lista dei 6 colori disponibili nel gioco
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  // Codice segreto da indovinare (4 colori casuali)
  late List<Color> _secret;
  
  // Sequenza di colori selezionata dal giocatore (inizialmente 4 colori grigi)
  late List<Color> _guess;
  
  // Messaggio che appare in alto per dare feedback al giocatore
  String _message = 'Indovina il codice segreto!';

  @override
  void initState() {
    super.initState();
    // Quando l'app si avvia, genera il codice segreto e inizializza i bottoni
    _newGame();
  }

  // Genera un nuovo codice segreto casuale e resetta i bottoni a grigio
  void _newGame() {
    final random = Random();
    // Crea 4 colori casuali dalla lista _colors
    _secret = List.generate(4, (_) => _colors[random.nextInt(_colors.length)]);
    // Crea 4 bottoni grigi
    _guess = List.generate(4, (_) => Colors.grey);
  }

  // Cambia il colore di un bottone quando viene premuto
  void _changeColor(int index) {
    setState(() {
      // Se il bottone è grigio, inizia dal primo colore
      if (_guess[index] == Colors.grey) {
        _guess[index] = _colors[0];
      } else {
        // Altrimenti passa al colore successivo nella lista
        // (quando arriva all'ultimo, ricomincia dal primo grazie al modulo %)
        int currentIndex = _colors.indexOf(_guess[index]);
        _guess[index] = _colors[(currentIndex + 1) % _colors.length];
      }
    });
  }

  // Controlla se il codice del giocatore corrisponde al codice segreto
  void _check() {
    setState(() {
      // Verifica che tutti i bottoni siano stati colorati
      if (_guess.contains(Colors.grey)) {
        _message = 'Seleziona tutti i colori!';
        return;
      }

      // Confronta ogni colore del giocatore con il codice segreto
      bool win = true;
      for (int i = 0; i < 4; i++) {
        if (_guess[i] != _secret[i]) {
          win = false;
          break;
        }
      }

      // Mostra il risultato e resetta i bottoni a grigio
      if (win) {
        _message = 'Hai vinto!';
        // Mostra un dialog di vittoria
        _showWin();
      } else {
        _message = 'Riprova!';
      }
      
      // Resetta i bottoni a grigio dopo ogni tentativo
      _guess = List.generate(4, (_) => Colors.grey);
    });
  }

  // Mostra un popup quando il giocatore vince
  void _showWin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hai vinto!'),
        content: const Text('Vuoi giocare ancora?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Chiude il popup
              setState(() {
                _newGame(); // Inizia una nuova partita
                _message = 'Nuovo codice generato!';
              });
            },
            child: const Text('Nuova partita'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superiore con il titolo
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Messaggio di feedback per il giocatore
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                _message,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // I 4 bottoni circolari per selezionare i colori
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    // Quando premuto, cambia il colore del bottone
                    onPressed: () => _changeColor(i),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _guess[i], // Colore del bottone
                      minimumSize: const Size(70, 70), // Dimensione 70x70
                      shape: const CircleBorder(), // Forma circolare
                    ),
                    child: const SizedBox(), // Bottone vuoto (solo colore)
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 30),
            
            // Legenda: mostra tutti i colori disponibili
            const Text('Colori disponibili:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _colors.map((color) {
                return Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black38),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      
      // Bottone floating in basso a destra per verificare la giocata
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _check, // Quando premuto, verifica il codice
        icon: const Icon(Icons.check),
        label: const Text('Verifica'),
      ),
    );
  }
}
