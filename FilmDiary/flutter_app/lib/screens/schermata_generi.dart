import 'package:flutter/material.dart';
import '../models/genere.dart';
import '../services/repository.dart';

// -----------------------------------------------
// FilmDiary – SchermataGeneri
// Gestione CRUD dei generi cinematografici.
// Creazione e modifica tramite AlertDialog.
// Eliminazione con richiesta di conferma.
// -----------------------------------------------

class SchermataGeneri extends StatefulWidget {
  const SchermataGeneri({super.key});

  @override
  State<SchermataGeneri> createState() => _StatoSchermataGeneri();
}

class _StatoSchermataGeneri extends State<SchermataGeneri> {
  final _repository  = Repository();
  List<Genere> _generi     = [];
  bool         _caricamento = true;

  static const _paletteColori = [
    '#F44336', '#E91E63', '#9C27B0', '#673AB7',
    '#3F51B5', '#2196F3', '#03A9F4', '#00BCD4',
    '#009688', '#4CAF50', '#8BC34A', '#CDDC39',
    '#FFC107', '#FF9800', '#FF5722', '#795548',
    '#607D8B', '#212121',
  ];

  @override
  void initState() {
    super.initState();
    _caricaGeneri();
  }

  Future<void> _caricaGeneri() async {
    setState(() => _caricamento = true);
    final generi = await _repository.ottieniGeneri();
    setState(() { _generi = generi; _caricamento = false; });
  }

  Color _esadecimaleAColore(String esadecimale) {
    final hex = esadecimale.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  // ---- Dialog per creazione / modifica ----
  Future<void> _mostraModulo({Genere? genere}) async {
    final controlloreNome = TextEditingController(text: genere?.nome ?? '');
    String coloreSelezionato = genere?.colore ?? '#607D8B';

    await showDialog(
      context: context,
      builder: (contesto) => StatefulBuilder(
        builder: (contesto2, aggiornaLocale) => AlertDialog(
          title: Text(genere == null ? 'Nuovo genere' : 'Modifica genere'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller:         controlloreNome,
                  autofocus:          true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText:  'Nome genere',
                    prefixIcon: Icon(Icons.label_outline),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Colore',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _paletteColori.map((esadecimale) {
                    final selezionato = coloreSelezionato == esadecimale;
                    return GestureDetector(
                      onTap: () => aggiornaLocale(() => coloreSelezionato = esadecimale),
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color:  _esadecimaleAColore(esadecimale),
                          shape:  BoxShape.circle,
                          border: selezionato
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                          boxShadow: selezionato
                              ? [BoxShadow(
                                  color:     _esadecimaleAColore(esadecimale).withOpacity(0.6),
                                  blurRadius: 6,
                                )]
                              : null,
                        ),
                        child: selezionato
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contesto),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () async {
                final nome = controlloreNome.text.trim();
                if (nome.isEmpty) return;

                Navigator.pop(contesto);

                final nuovoGenere = Genere(
                  id:     genere?.id,
                  nome:   nome,
                  colore: coloreSelezionato,
                );

                final risultato = genere == null
                    ? await _repository.creaGenere(nuovoGenere)
                    : await _repository.aggiornaGenere(genere.id!, nuovoGenere);

                if (risultato == null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:         Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.warning_amber_outlined, size: 16, color: Colors.white), SizedBox(width: 8), Text('Server non raggiungibile – operazione non eseguita')]),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
                _caricaGeneri();
              },
              child: const Text('Salva'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confermaEliminazione(Genere genere) async {
    final confermato = await showDialog<bool>(
      context: context,
      builder: (contesto) => AlertDialog(
        title: const Text('Elimina genere'),
        content: Text(
          'Vuoi eliminare "${genere.nome}"?\n\n'
          'I film associati non verranno eliminati.',
        ),
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

    final riuscito = await _repository.eliminaGenere(genere.id!);
    if (!riuscito && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.warning_amber_outlined, size: 16, color: Colors.white), SizedBox(width: 8), Text('Server non raggiungibile – eliminazione non eseguita')]),
          backgroundColor: Colors.orange,
        ),
      );
    }
    _caricaGeneri();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generi')),
      body: _caricamento
          ? const Center(child: CircularProgressIndicator())
          : _generi.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.category_outlined, size: 64, color: Colors.grey[600]),
                      const SizedBox(height: 12),
                      Text('Nessun genere', style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
                  itemCount: _generi.length,
                  itemBuilder: (contesto, indice) {
                    final genere = _generi[indice];
                    final colore = _esadecimaleAColore(genere.coloreEsadecimale);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colore.withOpacity(0.2),
                          child: Icon(Icons.label_rounded, color: colore),
                        ),
                        title: Text(genere.nome, style: const TextStyle(fontWeight: FontWeight.w500)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon:    const Icon(Icons.edit_outlined, size: 20),
                              tooltip: 'Modifica',
                              onPressed: () => _mostraModulo(genere: genere),
                            ),
                            IconButton(
                              icon:    const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                              tooltip: 'Elimina',
                              onPressed: () => _confermaEliminazione(genere),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostraModulo(),
        tooltip:   'Aggiungi genere',
        child:     const Icon(Icons.add),
      ),
    );
  }
}
