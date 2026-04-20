import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/film.dart';
import '../models/genere.dart';

class ServizioApi {
  static const String _urlBase = 'http://172.20.10.3:3000';
  static String get urlBase => _urlBase;

  static const Duration _timeout = Duration(seconds: 10);
  static const Map<String, String> _intestazioni = {'Content-Type': 'application/json'};

  static Future<List<Genere>> ottieniGeneri() async {
    final risposta = await http.get(Uri.parse('$urlBase/generi')).timeout(_timeout);
    
    if (risposta.statusCode == 200) {
      final dati = jsonDecode(risposta.body);
      if (dati is List) {
        return dati.map((e) => Genere.daJson(e as Map<String, dynamic>)).toList();
      } else {
        return (dati['generi'] as List).map((e) => Genere.daJson(e as Map<String, dynamic>)).toList();
      }
    }
    throw Exception('Errore nel caricamento generi');
  }

  static Future<Genere> creaGenere(Genere genere) async {
    final esistenti = await ottieniGeneri();
    int nuovoId = 1;
    if (esistenti.isNotEmpty) {
      nuovoId = esistenti.map((g) => g.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }

    final mappaDati = genere.aJson();
    mappaDati['id'] = nuovoId;

    final risposta = await http
        .post(Uri.parse('$urlBase/generi'), headers: _intestazioni, body: jsonEncode(mappaDati))
        .timeout(_timeout);
    return Genere.daJson(jsonDecode(risposta.body) as Map<String, dynamic>);
  }

  static Future<Genere> aggiornaGenere(int id, Genere genere) async {
    final risposta = await http
        .put(Uri.parse('$urlBase/generi/$id'), headers: _intestazioni, body: jsonEncode(genere.aJson()))
        .timeout(_timeout);
    return Genere.daJson(jsonDecode(risposta.body) as Map<String, dynamic>);
  }

  static Future<Genere> aggiornaParzialmenteGenere(int id, Map<String, dynamic> campi) async {
    final risposta = await http
        .patch(Uri.parse('$urlBase/generi/$id'), headers: _intestazioni, body: jsonEncode(campi))
        .timeout(_timeout);
    return Genere.daJson(jsonDecode(risposta.body) as Map<String, dynamic>);
  }

  static Future<void> eliminaGenere(int id) async {
    await http.delete(Uri.parse('$urlBase/generi/$id')).timeout(_timeout);
  }

  static Future<List<Film>> ottienFilm({int? genereId, String? stato}) async {
    final parametri = <String, String>{};
    if (genereId != null) parametri['genere_id'] = genereId.toString();
    if (stato != null) parametri['stato'] = stato;

    final uri = Uri.parse('$urlBase/film').replace(
      queryParameters: parametri.isNotEmpty ? parametri : null,
    );
    
    final risposta = await http.get(uri).timeout(_timeout);
    
    if (risposta.statusCode == 200) {
      final dati = jsonDecode(risposta.body);
      if (dati is List) {
        return dati.map((e) => Film.daJson(e as Map<String, dynamic>)).toList();
      } else if (dati is Map && dati.containsKey('film')) {
        return (dati['film'] as List).map((e) => Film.daJson(e as Map<String, dynamic>)).toList();
      }
    }
    return [];
  }

  static Future<Film> ottieniFilm(int id) async {
    final risposta = await http.get(Uri.parse('$urlBase/film/$id')).timeout(_timeout);
    return Film.daJson(jsonDecode(risposta.body) as Map<String, dynamic>);
  }

  static Future<Film> creaFilm(Film film) async {
    final esistenti = await ottienFilm();
    int nuovoId = 1;
    if (esistenti.isNotEmpty) {
      nuovoId = esistenti.map((f) => f.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }

    final mappaDati = film.aJson();
    mappaDati['id'] = nuovoId;

    final risposta = await http
        .post(Uri.parse('$urlBase/film'), headers: _intestazioni, body: jsonEncode(mappaDati))
        .timeout(_timeout);
    return Film.daJson(jsonDecode(risposta.body) as Map<String, dynamic>);
  }

  static Future<Film> aggiornaFilm(int id, Film film) async {
    final risposta = await http
        .put(Uri.parse('$urlBase/film/$id'), headers: _intestazioni, body: jsonEncode(film.aJson()))
        .timeout(_timeout);
    return Film.daJson(jsonDecode(risposta.body) as Map<String, dynamic>);
  }

  static Future<Film> aggiornaParzialmenteFilm(int id, Map<String, dynamic> campi) async {
    final risposta = await http
        .patch(Uri.parse('$urlBase/film/$id'), headers: _intestazioni, body: jsonEncode(campi))
        .timeout(_timeout);
    return Film.daJson(jsonDecode(risposta.body) as Map<String, dynamic>);
  }

  static Future<void> eliminaFilm(int id) async {
    try {
      final risposta = await http.delete(Uri.parse('$urlBase/film/$id')).timeout(_timeout);
      if (risposta.statusCode != 200 && risposta.statusCode != 204) {
        throw Exception('Errore durante l\'eliminazione: ${risposta.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}