import 'package:flutter/material.dart';
import '../services/repository.dart';
import 'schermata_lista_film.dart';
import 'schermata_generi.dart';

class SchermataPrincipale extends StatefulWidget {
  const SchermataPrincipale({super.key});

  @override
  State<SchermataPrincipale> createState() => _StatoSchermataPrincipale();
}

class _StatoSchermataPrincipale extends State<SchermataPrincipale> {
  final _repository  = Repository();
  Map<String, int> _statistiche = {};
  bool _connesso    = true;
  bool _caricamento = true;

  @override
  void initState() {
    super.initState();
    _caricaDati();
  }

  Future<void> _caricaDati() async {
    setState(() => _caricamento = true);
    await _repository.ottieniFilm();
    final statistiche = await _repository.ottieniStatistiche();
    setState(() {
      _statistiche = statistiche;
      _connesso    = _repository.connesso;
      _caricamento = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film Diary'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Gestisci generi',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SchermataGeneri()),
            ).then((_) => _caricaDati()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _caricaDati,
        child: _caricamento
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (!_connesso) _BannerOffline(),
                  const SizedBox(height: 8),

                  Text(
                    'Il tuo diario',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_statistiche['totale'] ?? 0} film catalogati',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 24),

                  _SchedaStatistica(
                    etichetta: 'Film visti',
                    valore:    _statistiche['visti'] ?? 0,
                    icona:     Icons.check_circle_outline,
                    colore:    Colors.greenAccent,
                  ),
                  const SizedBox(height: 12),
                  _SchedaStatistica(
                    etichetta: 'Da vedere',
                    valore:    _statistiche['da_vedere'] ?? 0,
                    icona:     Icons.bookmark_outline,
                    colore:    Colors.orangeAccent,
                  ),
                  const SizedBox(height: 12),
                  _SchedaStatistica(
                    etichetta: 'In corso',
                    valore:    _statistiche['in_corso'] ?? 0,
                    icona:     Icons.play_circle_outline,
                    colore:    Colors.deepPurpleAccent,
                  ),
                  const SizedBox(height: 32),

                  FilledButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SchermataListaFilm()),
                    ).then((_) => _caricaDati()),
                    icon:  const Icon(Icons.movie_filter_outlined),
                    label: const Text('Sfoglia tutti i film'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _BannerOffline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.orange, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Server non raggiungibile - dati dalla cache locale',
              style: TextStyle(color: Colors.orange[300], fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _SchedaStatistica extends StatelessWidget {
  final String   etichetta;
  final int      valore;
  final IconData icona;
  final Color    colore;

  const _SchedaStatistica({
    required this.etichetta,
    required this.valore,
    required this.icona,
    required this.colore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: colore.withOpacity(0.15),
          child: Icon(icona, color: colore, size: 22),
        ),
        title: Text(etichetta, style: const TextStyle(fontSize: 15)),
        trailing: Text(
          valore.toString(),
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: colore),
        ),
      ),
    );
  }
}
