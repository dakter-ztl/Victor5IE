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

    try {
      final nuovoFilm = Film(
        id:           widget.film?.id,
        titolo:       _controlloreTitolo.text.trim(),
        anno:         _controlloreAnno.text.isNotEmpty ? int.tryParse(_controlloreAnno.text) : null,
        regista:      _controlloreRegista.text.trim().isEmpty ? null : _controlloreRegista.text.trim(),
        genereId:     _genereId,
        urlLocandina: _controlloreLocandina.text.trim().isEmpty ? null : _controlloreLocandina.text.trim(),
        stato:        _stato,
        valutazione:  _valutazione > 0 ? _valutazione : null,
        recensione:   _controlloreRecensione.text.trim().isEmpty ? null : _controlloreRecensione.text.trim(),
      );

      Film? risultato;
      if (_inModifica) {
        final idDaModificare = widget.film?.id;
        if (idDaModificare != null) {
          risultato = await _repository.aggiornaFilm(idDaModificare, nuovoFilm);
        }
      } else {
        risultato = await _repository.creaFilm(nuovoFilm);
      }

      if (!mounted) return;

      if (risultato == null) {
        setState(() => _salvataggio = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(children: [Icon(Icons.error_outline, color: Colors.white), SizedBox(width: 8), Text('Errore di connessione')]),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _salvataggio = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e'), backgroundColor: Colors.red),
        );
      }
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
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else
            TextButton(onPressed: _salva, child: const Text('Salva')),
        ],
      ),
      body: Form(
        key: _chiaveForm,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _controlloreTitolo,
              decoration: const InputDecoration(labelText: 'Titolo *', prefixIcon: Icon(Icons.movie_outlined)),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Obbligatorio' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _controlloreAnno,
                    decoration: const InputDecoration(labelText: 'Anno', prefixIcon: Icon(Icons.calendar_today_outlined)),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _controlloreRegista,
                    decoration: const InputDecoration(labelText: 'Regista', prefixIcon: Icon(Icons.person_outlined)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int?>(
              value: _genereId,
              decoration: const InputDecoration(labelText: 'Genere', prefixIcon: Icon(Icons.category_outlined)),
              items: [
                const DropdownMenuItem(value: null, child: Text('Nessuno')),
                ...widget.generi.map((g) => DropdownMenuItem(value: g.id, child: Text(g.nome))),
              ],
              onChanged: (v) => setState(() => _genereId = v),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _stato,
              decoration: const InputDecoration(labelText: 'Stato', prefixIcon: Icon(Icons.flag_outlined)),
              items: const [
                DropdownMenuItem(value: 'da_vedere', child: Text('Da vedere')),
                DropdownMenuItem(value: 'in_corso', child: Text('In corso')),
                DropdownMenuItem(value: 'visto', child: Text('Visto')),
              ],
              onChanged: (v) => setState(() => _stato = v ?? 'da_vedere'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controlloreLocandina,
              decoration: const InputDecoration(labelText: 'URL Locandina', prefixIcon: Icon(Icons.image_outlined)),
            ),
            if (_stato == 'visto') ...[
              const SizedBox(height: 20),
              ValutazioneStelle(
                valutazione: _valutazione,
                alCambiamento: (v) => setState(() => _valutazione = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controlloreRecensione,
                decoration: const InputDecoration(labelText: 'Recensione', prefixIcon: Icon(Icons.edit_note_outlined)),
                maxLines: 3,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _salvataggio ? null : _salva,
              child: Text(_inModifica ? 'Aggiorna' : 'Aggiungi'),
            ),
          ],
        ),
      ),
    );
  }
}