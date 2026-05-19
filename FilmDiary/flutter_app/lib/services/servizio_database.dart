import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/film.dart';
import '../models/genere.dart';

class ServizioDatabase {
  static final ServizioDatabase _istanza = ServizioDatabase._interno();
  factory ServizioDatabase() => _istanza;
  ServizioDatabase._interno();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _inizializzaDb();
    return _db!;
  }

  Future<Database> _inizializzaDb() async {
    final percorso = join(await getDatabasesPath(), 'filmdiary_cache.db');
    return openDatabase(
      percorso,
      version: 1,
      onCreate: _allaCreazione,
    );
  }

  Future<void> _allaCreazione(Database db, int versione) async {
    await db.execute('''
      CREATE TABLE generi (
        id         INTEGER PRIMARY KEY,
        nome       TEXT NOT NULL,
        colore     TEXT NOT NULL DEFAULT "#607D8B",
        creato_il  TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE film (
        id             INTEGER PRIMARY KEY,
        titolo         TEXT NOT NULL,
        anno           INTEGER,
        regista        TEXT,
        genere_id      INTEGER,
        nome_genere    TEXT,
        colore_genere  TEXT,
        url_locandina  TEXT,
        stato          TEXT NOT NULL DEFAULT "da_vedere",
        valutazione    INTEGER,
        recensione     TEXT,
        creato_il      TEXT,
        aggiornato_il  TEXT
      )
    ''');
  }

  Future<List<Genere>> ottieniGeneri() async {
    final db    = await database;
    final righe = await db.query('generi', orderBy: 'nome');
    return righe.map(Genere.daMappa).toList();
  }

  Future<void> salvaGenere(Genere genere) async {
    final db = await database;
    await db.insert('generi', genere.aMappa(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> sostituisciGeneri(List<Genere> generi) async {
    final db  = await database;
    final lotto = db.batch();
    lotto.delete('generi'); // Svuota per sincronizzare
    for (final genere in generi) {
      lotto.insert('generi', genere.aMappa(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await lotto.commit(noResult: true);
  }

  Future<void> eliminaGenere(int id) async {
    final db = await database;
    await db.delete('generi', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Film>> ottieniFilm({int? genereId, String? stato}) async {
    final db = await database;

    String? condizione;
    List<dynamic>? valori;

    if (genereId != null && stato != null) {
      condizione = 'genere_id = ? AND stato = ?';
      valori     = [genereId, stato];
    } else if (genereId != null) {
      condizione = 'genere_id = ?';
      valori     = [genereId];
    } else if (stato != null) {
      condizione = 'stato = ?';
      valori     = [stato];
    }

    final righe = await db.query(
      'film',
      where:     condizione,
      whereArgs: valori,
      orderBy:   'titolo',
    );
    return righe.map(Film.daMappa).toList();
  }

  Future<Film?> ottieniSingoloFilm(int id) async {
    final db    = await database;
    final righe = await db.query('film', where: 'id = ?', whereArgs: [id]);
    return righe.isNotEmpty ? Film.daMappa(righe.first) : null;
  }

  Future<void> salvaFilm(Film film) async {
    final db = await database;
    await db.insert('film', film.aMappa(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // --- MODIFICA QUI: Sincronizzazione reale ---
  Future<void> salvaListaFilm(List<Film> listaFilm) async {
    final db    = await database;
    final lotto = db.batch();
    
    // 1. ELIMINIAMO TUTTO IL CONTENUTO VECCHIO
    // Questo impedisce ai numeri delle statistiche di crescere all'infinito
    lotto.delete('film'); 
    
    // 2. RE-INSERIAMO SOLO QUELLO CHE C'È SUL SERVER
    for (final film in listaFilm) {
      lotto.insert('film', film.aMappa(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await lotto.commit(noResult: true);
  }

  Future<void> eliminaFilm(int id) async {
    final db = await database;
    await db.delete('film', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, int>> ottieniStatistiche() async {
    final db       = await database;
    final totale   = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM film'))                              ?? 0;
    final visti    = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM film WHERE stato = 'visto'"))        ?? 0;
    final daVedere = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM film WHERE stato = 'da_vedere'"))    ?? 0;
    final inCorso  = Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM film WHERE stato = 'in_corso'"))     ?? 0;
    return {
      'totale':    totale,
      'visti':     visti,
      'da_vedere': daVedere,
      'in_corso':  inCorso,
    };
  }
}