class Film {
  final int?    id;
  final String  titolo;
  final int?    anno;
  final String? regista;
  final int?    genereId;
  final String? nomeGenere;
  final String? coloreGenere;
  final String? urlLocandina;
  final String  stato;
  final int?    valutazione;
  final String? recensione;
  final String? creatoIl;
  final String? aggiornatoIl;

  const Film({
    this.id,
    required this.titolo,
    this.anno,
    this.regista,
    this.genereId,
    this.nomeGenere,
    this.coloreGenere,
    this.urlLocandina,
    this.stato = 'da_vedere',
    this.valutazione,
    this.recensione,
    this.creatoIl,
    this.aggiornatoIl,
  });

  factory Film.daJson(Map<String, dynamic> json) {
    return Film(
      id:            json['id']            != null ? int.parse(json['id'].toString())         : null,
      titolo:        json['titolo']        as String? ?? '',
      anno:          json['anno']          != null ? int.parse(json['anno'].toString())       : null,
      regista:       json['regista']       as String?,
      genereId:      json['genere_id']     != null ? int.parse(json['genere_id'].toString())  : null,
      nomeGenere:    json['nome_genere']   as String?,
      coloreGenere:  json['colore_genere'] as String?,
      urlLocandina:  json['url_locandina'] as String?,
      stato:         json['stato']         as String? ?? 'da_vedere',
      valutazione:   json['valutazione']   != null ? int.parse(json['valutazione'].toString()) : null,
      recensione:    json['recensione']    as String?,
      creatoIl:      json['creato_il']     as String?,
      aggiornatoIl:  json['aggiornato_il'] as String?,
    );
  }

  Map<String, dynamic> aJson() {
    return {
      if (id != null)           'id':            id,
      'titolo':                                  titolo,
      if (anno != null)         'anno':           anno,
      if (regista != null)      'regista':        regista,
      if (genereId != null)     'genere_id':      genereId,
      if (urlLocandina != null) 'url_locandina':  urlLocandina,
      'stato':                                   stato,
      if (valutazione != null)  'valutazione':    valutazione,
      if (recensione != null)   'recensione':     recensione,
    };
  }

  Map<String, dynamic> aMappa() {
    return {
      if (id != null)           'id':             id,
      'titolo':                                   titolo,
      'anno':                                     anno,
      'regista':                                  regista,
      'genere_id':                                genereId,
      'nome_genere':                              nomeGenere,
      'colore_genere':                            coloreGenere,
      'url_locandina':                            urlLocandina,
      'stato':                                    stato,
      'valutazione':                              valutazione,
      'recensione':                               recensione,
      'creato_il':                                creatoIl,
      'aggiornato_il':                            aggiornatoIl,
    };
  }

  factory Film.daMappa(Map<String, dynamic> mappa) {
    return Film(
      id:            mappa['id']             as int?,
      titolo:        mappa['titolo']         as String? ?? '',
      anno:          mappa['anno']           as int?,
      regista:       mappa['regista']        as String?,
      genereId:      mappa['genere_id']      as int?,
      nomeGenere:    mappa['nome_genere']    as String?,
      coloreGenere:  mappa['colore_genere']  as String?,
      urlLocandina:  mappa['url_locandina']  as String?,
      stato:         mappa['stato']          as String? ?? 'da_vedere',
      valutazione:   mappa['valutazione']    as int?,
      recensione:    mappa['recensione']     as String?,
      creatoIl:      mappa['creato_il']      as String?,
      aggiornatoIl:  mappa['aggiornato_il']  as String?,
    );
  }

  Film copiaCon({
    int?    id,
    String? titolo,
    int?    anno,
    String? regista,
    int?    genereId,
    String? nomeGenere,
    String? coloreGenere,
    String? urlLocandina,
    String? stato,
    int?    valutazione,
    String? recensione,
  }) {
    return Film(
      id:            id            ?? this.id,
      titolo:        titolo        ?? this.titolo,
      anno:          anno          ?? this.anno,
      regista:       regista       ?? this.regista,
      genereId:      genereId      ?? this.genereId,
      nomeGenere:    nomeGenere    ?? this.nomeGenere,
      coloreGenere:  coloreGenere  ?? this.coloreGenere,
      urlLocandina:  urlLocandina  ?? this.urlLocandina,
      stato:         stato         ?? this.stato,
      valutazione:   valutazione   ?? this.valutazione,
      recensione:    recensione    ?? this.recensione,
      creatoIl:      creatoIl,
      aggiornatoIl:  aggiornatoIl,
    );
  }

  @override
  String toString() => 'Film(id: $id, titolo: $titolo, stato: $stato)';
}
