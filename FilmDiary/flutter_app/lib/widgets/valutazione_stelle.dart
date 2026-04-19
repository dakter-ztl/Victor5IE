import 'package:flutter/material.dart';

class ValutazioneStelle extends StatelessWidget {
  final int valutazione;
  final ValueChanged<int> alCambiamento;
  final double dimensione;
  final bool solLettura;

  const ValutazioneStelle({
    super.key,
    required this.valutazione,
    required this.alCambiamento,
    this.dimensione  = 32,
    this.solLettura  = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (indice) {
        final riempita = indice < valutazione;
        return GestureDetector(
          onTap: solLettura
              ? null
              : () => alCambiamento(valutazione == indice + 1 ? 0 : indice + 1),
          child: Icon(
            riempita ? Icons.star_rounded : Icons.star_border_rounded,
            color: riempita ? Colors.amber : Colors.grey,
            size:  dimensione,
          ),
        );
      }),
    );
  }
}
