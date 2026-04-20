import 'package:flutter/material.dart';
import '../models/film.dart';
import '../models/genere.dart';
import 'valutazione_stelle.dart';

class CardFilm extends StatelessWidget {
  final Film       film;
  final Genere?    genere;
  final VoidCallback alTocco;
  final VoidCallback allaEliminazione;

  const CardFilm({
    super.key,
    required this.film,
    this.genere,
    required this.alTocco,
    required this.allaEliminazione,
  });

  Color get _coloreStato {
    return switch (film.stato) {
      'visto'    => Colors.green,
      'in_corso' => Colors.deepPurple,
      _          => Colors.orange,
    };
  }

  String get _etichettaStato {
    return switch (film.stato) {
      'visto'    => 'Visto',
      'in_corso' => 'In corso',
      _          => 'Da vedere',
    };
  }

  IconData get _iconaStato {
    return switch (film.stato) {
      'visto'    => Icons.check_circle_outline,
      'in_corso' => Icons.play_circle_outline,
      _          => Icons.bookmark_outline,
    };
  }

  Color _esadecimaleAColore(String esadecimale) {
    final hex = esadecimale.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final coloreGenere = genere != null
        ? _esadecimaleAColore(genere!.coloreEsadecimale)
        : Colors.grey;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      elevation: 2,
      child: InkWell(
        onTap: alTocco,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: film.urlLocandina != null && film.urlLocandina!.isNotEmpty
                    ? Image.network(
                        film.urlLocandina!,
                        width: 52, height: 76, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _Segnaposto(colore: coloreGenere),
                      )
                    : _Segnaposto(colore: coloreGenere),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      film.titolo,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (film.anno != null || film.regista != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        [
                          if (film.anno    != null) film.anno.toString(),
                          if (film.regista != null) film.regista!,
                        ].join(' · '),
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (genere != null)
                          _Etichetta(testo: genere!.nome, colore: coloreGenere),
                        _Etichetta(testo: _etichettaStato, colore: _coloreStato, icona: _iconaStato),
                      ],
                    ),
                    if (film.valutazione != null) ...[
                      const SizedBox(height: 4),
                      ValutazioneStelle(
                        valutazione:   film.valutazione!,
                        alCambiamento: (_) {},
                        dimensione:    16,
                        solLettura:    true,
                      ),
                    ],
                  ],
                ),
              ),

              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                onPressed: allaEliminazione,
                tooltip: 'Elimina',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Segnaposto extends StatelessWidget {
  final Color colore;
  const _Segnaposto({required this.colore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52, height: 76,
      decoration: BoxDecoration(
        color: colore.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.movie_outlined, color: colore.withOpacity(0.6), size: 28),
    );
  }
}

class _Etichetta extends StatelessWidget {
  final String    testo;
  final Color     colore;
  final IconData? icona;
  const _Etichetta({required this.testo, required this.colore, this.icona});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: colore.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icona != null) ...[
            Icon(icona, color: colore, size: 11),
            const SizedBox(width: 3),
          ],
          Text(
            testo,
            style: TextStyle(color: colore, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
