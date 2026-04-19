import 'package:flutter/material.dart';
import '../models/film.dart';
import '../models/genere.dart';
import '../services/repository.dart';
import '../widgets/valutazione_stelle.dart';

class SchermataModuloFilm extends StatefulWidget {
  final Film?       film;
  final List<Genere> generi;

  const SchermataModuloFilm({super.key, this.film, required this.generi});

  @override
  State<SchermataModuloFilm> createState() => _StatoSchermataModuloFilm();
}

class _StatoSchermataModuloFilm extends State<SchermataModuloFilm> {
  final _chiaveForm  = GlobalKey<FormState>();
  final _repository  = Repository();

  late final TextEditingController _controlloreTitolo;
  late final TextEditingController _controlloreAnno;
  late final TextEditingController _controlloreRegista;
  late final TextEditingController _controlloreLocandina;
  late final TextEditingController _controlloreRecensione;

  String _stato       = 'da_vedere';
  int    _valutazione = 0;
  int?   _genereId;
  bool   _salvataggio = false;

  bool get _inModifica => widget.film != null;

  @override
  void initState() {
    super.initState();
    final f              = widget.film;
    _controlloreTitolo    = TextEditingController(text: f?.titolo          ?? '');
    _controlloreAnno      = TextEditingController(text: f?.anno?.toString() ?? '');
    _controlloreRegista   = TextEditingController(text: f?.regista          ?? '');
    _controlloreLocandina = TextEditingController(text: f?.urlLocandina     ?? '');
    _controlloreRecensione= TextEditingController(text: f?.recensione       ?? '');
    _stato                = f?.stato       ?? 'da_vedere';
    _valutazione          = f?.valutazione ?? 0;
    _genereId             = f?.genereId;
  }

  @override
  void dispose() {
    _controlloreTitolo.dispose();
    _controlloreAnno.dispose();
    _controlloreRegista.dispose();
    _controlloreLocandina.dispose();
    _controlloreRecensione.dispose();
    super.dispose();
  }

  Future<void> _salva() async {
    if (!_chiaveForm.currentState!.validate()) return;
    setState(() => _salvataggio = true);

    final nuovoFilm = Film(
      id:           widget.film?.id,
      titolo:       _controlloreTitolo.text.trim(),
      anno:         _controlloreAnno.text.isNotEmpty ? int.tryParse(_controlloreAnno.text) : null,
      regista:      _controlloreRegista.text.trim().isEmpty   ? null : _controlloreRegista.text.trim(),
      genereId:     _genereId,
      urlLocandina: _controlloreLocandina.text.trim().isEmpty ? null : _controlloreLocandina.text.trim(),
      stato:        _stato,
      valutazione:  _valutazione > 0 ? _valutazione : null,
      recensione:   _controlloreRecensione.text.trim().isEmpty? null : _controlloreRecensione.text.trim(),
    );

    Film? risultato;
    if (_inModifica) {
      risultato = await _repository.aggiornaFilm(widget.film!.id!, nuovoFilm);
    } else {
      risultato = await _repository.creaFilm(nuovoFilm);
    }

    setState(() => _salvataggio = false);

    if (!mounted) return;

    if (risultato == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text(' Server non raggiungibile - salvataggio non eseguito'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_inModifica ? 'Modifica film' : 'Nuovo film'),
        actions: [
          if (_salvataggio)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _salva,
              child: const Text('Salva'),
            ),
        ],
      ),
      body: Form(
        key: _chiaveForm,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller:          _controlloreTitolo,
              decoration: const InputDecoration(
                labelText:  'Titolo *',
                prefixIcon: Icon(Icons.movie_outlined),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (valore) =>
                  (valore == null || valore.trim().isEmpty) ? 'Il titolo è obbligatorio' : null,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller:   _controlloreAnno,
                    decoration: const InputDecoration(
                      labelText:  'Anno',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (valore) {
                      if (valore == null || valore.isEmpty) return null;
                      final anno = int.tryParse(valore);
                      if (anno == null || anno < 1888 || anno > 2100) return 'Anno non valido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller:         _controlloreRegista,
                    decoration: const InputDecoration(
                      labelText:  'Regista',
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<int?>(
              initialValue:     _genereId,
              decoration: const InputDecoration(
                labelText:  'Genere',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('— Nessun genere —')),
                ...widget.generi.map(
                  (genere) => DropdownMenuItem(value: genere.id, child: Text(genere.nome)),
                ),
              ],
              onChanged: (valore) => setState(() => _genereId = valore),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue:     _stato,
              decoration: const InputDecoration(
                labelText:  'Stato',
                prefixIcon: Icon(Icons.flag_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'da_vedere', child: Text(' Da vedere')),
                DropdownMenuItem(value: 'in_corso',  child: Text(' In corso')),
                DropdownMenuItem(value: 'visto',     child: Text(' Visto')),
              ],
              onChanged: (valore) => setState(() => _stato = valore ?? 'da_vedere'),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller:   _controlloreLocandina,
              decoration: const InputDecoration(
                labelText:  'URL Locandina (opzionale)',
                prefixIcon: Icon(Icons.image_outlined),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),

            if (_stato == 'visto') ...[
              Text('Valutazione', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              ValutazioneStelle(
                valutazione:   _valutazione,
                alCambiamento: (v) => setState(() => _valutazione = v),
                dimensione:    38,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller:         _controlloreRecensione,
                decoration: const InputDecoration(
                  labelText:        'Recensione personale',
                  prefixIcon:       Icon(Icons.edit_note_outlined),
                  alignLabelWithHint: true,
                ),
                maxLines:           5,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
            ],

            FilledButton(
              onPressed: _salvataggio ? null : _salva,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(_inModifica ? 'Aggiorna film' : 'Aggiungi film'),
            ),
          ],
        ),
      ),
    );
  }
}
