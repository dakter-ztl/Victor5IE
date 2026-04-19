import 'package:flutter/material.dart';
import '../models/film.dart';
import '../models/genere.dart';
import '../services/repository.dart';
import '../widgets/card_film.dart';
import 'schermata_modulo_film.dart';

class SchermataListaFilm extends StatefulWidget {
  const SchermataListaFilm({super.key});

  @override
  State<SchermataListaFilm> createState() => _StatoSchermataListaFilm();
}

class _StatoSchermataListaFilm extends State<SchermataListaFilm> {
  final _repository = Repository();

  List<Film>   _listaFilm  = [];
  List<Genere> _generi     = [];
  String?      _statoSel;
  int?         _genereSel;
  bool         _caricamento = true;

  static const _opzioniStato = [
    (valore: null,        etichetta: 'Tutti'),
    (valore: 'da_vedere', etichetta: ' Da vedere'),
    (valore: 'in_corso',  etichetta: ' In corso'),
    (valore: 'visto',     etichetta: ' Visto'),
  ];

  @override
  void initState() {
    super.initState();
    _caricaTutto();
  }

  Future<void> _caricaTutto() async {
    setState(() => _caricamento = true);
    final generi    = await _repository.ottieniGeneri();
    final listaFilm = await _repository.ottieniFilm(
      genereId: _genereSel,
      stato:    _statoSel,
    );
    setState(() {
      _generi     = generi;
      _listaFilm  = listaFilm;
      _caricamento = false;
    });
  }

  Future<void> _confermaEliminazione(Film film) async {
    final confermato = await showDialog<bool>(
      context: context,
      builder: (contesto) => AlertDialog(
        title: const Text('Elimina film'),
        content: Text('Vuoi eliminare "${film.titolo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contesto, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(contesto, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confermato != true) return;

    final riuscito = await _repository.eliminaFilm(film.id!);
    if (!riuscito && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(' Server non raggiungibile - eliminazione non eseguita'),
          backgroundColor: Colors.orange,
        ),
      );
    }
    _caricaTutto();
  }

  Genere? _genereDelFilm(Film film) {
    try {
      return _generi.firstWhere((g) => g.id == film.genereId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film'),
        actions: [
          if (!_repository.connesso)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.wifi_off_rounded, color: Colors.orange),
            ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              children: _opzioniStato.map((opzione) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label:    Text(opzione.etichetta),
                    selected: _statoSel == opzione.valore,
                    onSelected: (_) {
                      setState(() => _statoSel = opzione.valore);
                      _caricaTutto();
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          if (_generi.isNotEmpty)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label:    const Text('Tutti i generi'),
                      selected: _genereSel == null,
                      onSelected: (_) {
                        setState(() => _genereSel = null);
                        _caricaTutto();
                      },
                    ),
                  ),
                  ..._generi.map((genere) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label:    Text(genere.nome),
                        selected: _genereSel == genere.id,
                        onSelected: (_) {
                          setState(() => _genereSel = genere.id);
                          _caricaTutto();
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

          const Divider(height: 1),

          Expanded(
            child: _caricamento
                ? const Center(child: CircularProgressIndicator())
                : _listaFilm.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.movie_creation_outlined, size: 64, color: Colors.grey[600]),
                            const SizedBox(height: 12),
                            Text('Nessun film trovato', style: TextStyle(color: Colors.grey[500])),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _caricaTutto,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
                          itemCount: _listaFilm.length,
                          itemBuilder: (contesto, indice) {
                            final film = _listaFilm[indice];
                            return CardFilm(
                              film:              film,
                              genere:            _genereDelFilm(film),
                              alTocco:           () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SchermataModuloFilm(
                                    film:   film,
                                    generi: _generi,
                                  ),
                                ),
                              ).then((_) => _caricaTutto()),
                              allaEliminazione: () => _confermaEliminazione(film),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SchermataModuloFilm(generi: _generi),
          ),
        ).then((_) => _caricaTutto()),
        tooltip: 'Aggiungi film',
        child: const Icon(Icons.add),
      ),
    );
  }
}
