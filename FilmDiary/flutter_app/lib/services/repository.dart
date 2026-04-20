import '../models/film.dart';
import '../models/genere.dart';
import 'servizio_api.dart';
import 'servizio_database.dart';

class Repository {
  final ServizioDatabase _db = ServizioDatabase();

  bool _connesso = true;

  bool get connesso => _connesso;


  Future<List<Genere>> ottieniGeneri() async {
    try {
      final generi = await ServizioApi.ottieniGeneri();
      await _db.sostituisciGeneri(generi);
      _connesso = true;
      return generi;
    } catch (e) {
      print('[Repository] errore: $e');
      _connesso = false;
      return _db.ottieniGeneri();
    }
  }

  Future<Genere?> creaGenere(Genere genere) async {
    try {
      final creato = await ServizioApi.creaGenere(genere);
      await _db.salvaGenere(creato);
      _connesso = true;
      return creato;
    } catch (e) {
      print('[Repository] errore: $e');
      _connesso = false;
      return null;
    }
  }

  Future<Genere?> aggiornaGenere(int id, Genere genere) async {
    try {
      final aggiornato = await ServizioApi.aggiornaGenere(id, genere);
      await _db.salvaGenere(aggiornato);
      _connesso = true;
      return aggiornato;
    } catch (e) {
      print('[Repository] errore: $e');
      _connesso = false;
      return null;
    }
  }

  Future<Genere?> aggiornaParzialmenteGenere(int id, Map<String, dynamic> campi) async {
    try {
      final aggiornato = await ServizioApi.aggiornaParzialmenteGenere(id, campi);
      await _db.salvaGenere(aggiornato);
      _connesso = true;
      return aggiornato;
    } catch (e) {
      print('[Repository] errore: $e');
      _connesso = false;
      return null;
    }
  }

  Future<bool> eliminaGenere(int id) async {
    try {
      await ServizioApi.eliminaGenere(id);
      await _db.eliminaGenere(id);
      _connesso = true;
      return true;
    } catch (e) {
      print('[Repository] errore: $e');
      _connesso = false;
      return false;
    }
  }

  Future<List<Film>> ottieniFilm({int? genereId, String? stato}) async {
    try {
      final listaFilm = await ServizioApi.ottienFilm(genereId: genereId, stato: stato);
      await _db.salvaListaFilm(listaFilm);
      _connesso = true;
      return listaFilm;
    } catch (e) {
      print('[Repository] errore: $e');
      _connesso = false;
      return _db.ottieniFilm(genereId: genereId, stato: stato);
    }
  }

  Future<Film?> ottieniSingoloFilm(int id) async {
    try {
      final film = await ServizioApi.ottieniFilm(id);
      await _db.salvaFilm(film);
      _connesso = true;
      return film;
    } catch (e) {
      print('[Repository] errore: $e');
      _connesso = false;
      return _db.ottieniSingoloFilm(id);
    }
  }

  Future<Film?> creaFilm(Film film) async {
    try {
      final creato = await ServizioApi.creaFilm(film);
      await _db.salvaFilm(creato);
      _connesso = true;
      return creato;
    } catch (e) {
      print('[Repository] errore: $e');
      _connesso = false;
      return null;
    }
  }

  Future<Film?> aggiornaFilm(int id, Film film) async {
    try {
      final aggiornato = await ServizioApi.aggiornaFilm(id, film);
      await _db.salvaFilm(aggiornato);
      _connesso = true;
      return aggiornato;
    } catch (e) {
      print('[Repository] errore: $e');
      _connesso = false;
      return null;
    }
  }

  Future<Film?> aggiornaParzialmenteFilm(int id, Map<String, dynamic> campi) async {
    try {
      final aggiornato = await ServizioApi.aggiornaParzialmenteFilm(id, campi);
      await _db.salvaFilm(aggiornato);
      _connesso = true;
      return aggiornato;
    } catch (e) {
      print('[Repository] errore: $e');
      _connesso = false;
      return null;
    }
  }

  Future<bool> eliminaFilm(int id) async {
    try {
      await ServizioApi.eliminaFilm(id);
      await _db.eliminaFilm(id);
      _connesso = true;
      return true;
    } catch (e) {
      print('[Repository] errore: $e');
      _connesso = false;
      return false;
    }
  }

  Future<Map<String, int>> ottieniStatistiche() => _db.ottieniStatistiche();
}
