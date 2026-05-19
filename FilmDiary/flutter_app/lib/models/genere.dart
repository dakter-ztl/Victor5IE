class Genere {
  final int?    id;
  final String  nome;
  final String  colore;
  final String? creatoIl;

  const Genere({
    this.id,
    required this.nome,
    this.colore = '#607D8B',
    this.creatoIl,
  });

  factory Genere.daJson(Map<String, dynamic> json) {
    return Genere(
      id:       json['id']        != null ? int.parse(json['id'].toString()) : null,
      nome:     json['nome']      as String? ?? '',
      colore:   json['colore']    as String? ?? '#607D8B',
      creatoIl: json['creato_il'] as String?,
    );
  }

  Map<String, dynamic> aJson() {
    return {
      if (id != null) 'id': id,
      'nome':   nome,
      'colore': colore,
    };
  }

  Map<String, dynamic> aMappa() {
    return {
      if (id != null) 'id': id,
      'nome':      nome,
      'colore':    colore,
      'creato_il': creatoIl,
    };
  }

  factory Genere.daMappa(Map<String, dynamic> mappa) {
    return Genere(
      id:       mappa['id']        as int?,
      nome:     mappa['nome']      as String? ?? '',
      colore:   mappa['colore']    as String? ?? '#607D8B',
      creatoIl: mappa['creato_il'] as String?,
    );
  }

  String get coloreEsadecimale => colore.startsWith('#') ? colore : '#607D8B';

  @override
  String toString() => 'Genere(id: $id, nome: $nome)';
}
