import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chrono',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PaginaCronometro(),
    );
  }
}

class PaginaCronometro extends StatefulWidget {
  @override
  _PaginaCronometroState createState() => _PaginaCronometroState();
}

class _PaginaCronometroState extends State<PaginaCronometro> {
  StreamController<int> _controllerSecondi = StreamController<int>();
  StreamSubscription<int>? _subscriptionTicker;
  StreamSubscription<int>? _subscriptionSecondi;
  
  bool _inEsecuzione = false;
  bool _inPausa = false;
  int _secondiAttuali = 0;

  @override
  void initState() {
    super.initState();
  }

  // Ticker stream: genera eventi ogni 100ms
  Stream<int> _streamTicker() {
    return Stream.periodic(
      Duration(milliseconds: 100),
      (tick) => tick,
    );
  }

  // Secondo stream collegato al ticker: trasforma i tick in secondi
  // Questa è la pipe tra i due stream
  Stream<int> _streamSecondi(Stream<int> streamTicker) {
    return streamTicker
        .map((tick) => tick ~/ 10)
        .distinct();
  }

  void _avvia() {
    if (!_inEsecuzione) {
      setState(() {
        _inEsecuzione = true;
        _inPausa = false;
      });

      final ticker = _streamTicker();
      final secondi = _streamSecondi(ticker);
      
      _subscriptionTicker = secondi.listen((secondo) {
        setState(() {
          _secondiAttuali = secondo;
        });
      });
    }
  }

  void _ferma() {
    if (_inEsecuzione) {
      setState(() {
        _inEsecuzione = false;
        _inPausa = false;
      });
      
      _subscriptionTicker?.cancel();
    }
  }

  void _resetta() {
    _subscriptionTicker?.cancel();
    
    setState(() {
      _secondiAttuali = 0;
      _inEsecuzione = false;
      _inPausa = false;
    });
  }

  void _pausa() {
    if (_inEsecuzione && !_inPausa) {
      setState(() {
        _inPausa = true;
      });
      
      _subscriptionTicker?.pause();
    }
  }

  void _riprendi() {
    if (_inEsecuzione && _inPausa) {
      setState(() {
        _inPausa = false;
      });
      
      _subscriptionTicker?.resume();
    }
  }

  String _formattaTempo(int secondiTotali) {
    int minuti = secondiTotali ~/ 60;
    int secondi = secondiTotali % 60;
    return '${minuti.toString().padLeft(2, '0')}:${secondi.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chrono - Stopwatch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formattaTempo(_secondiAttuali),
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _inEsecuzione
                  ? (_inPausa ? 'IN PAUSA' : 'IN ESECUZIONE')
                  : 'FERMO',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Primo FAB: START -> STOP -> RESET
          FloatingActionButton(
            heroTag: 'controllo',
            onPressed: () {
              if (!_inEsecuzione) {
                _avvia();
              } else if (_inEsecuzione && !_inPausa) {
                _ferma();
              } else {
                _resetta();
              }
            },
            child: Icon(
              !_inEsecuzione
                  ? Icons.play_arrow
                  : (_inEsecuzione && !_inPausa ? Icons.stop : Icons.refresh),
            ),
            tooltip: !_inEsecuzione 
                ? 'Start' 
                : (_inEsecuzione && !_inPausa ? 'Stop' : 'Reset'),
          ),
          SizedBox(width: 16),
          // Secondo FAB: PAUSE <-> RESUME
          FloatingActionButton(
            heroTag: 'pausa',
            onPressed: () {
              if (_inEsecuzione) {
                if (_inPausa) {
                  _riprendi();
                } else {
                  _pausa();
                }
              }
            },
            child: Icon(_inPausa ? Icons.play_arrow : Icons.pause),
            tooltip: _inPausa ? 'Resume' : 'Pause',
            backgroundColor: _inEsecuzione ? Colors.blue : Colors.grey,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subscriptionTicker?.cancel();
    _subscriptionSecondi?.cancel();
    _controllerSecondi.close();
    super.dispose();
  }
}
