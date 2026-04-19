import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/film.dart';
import '../models/genere.dart';

class ServizioApi {
  static const String _urlBasePhp  = 'http://localhost/consegna_finale-2/server';
  static const String _urlBaseMock = 'http://localhost:3000';
  static const bool   _usaMock     = false;

  static String get urlBase => _usaMock ? _urlBaseMock : _urlBasePhp;

  static const Duration _timeout   = Duration(seconds: 5);
  static const Map<String, String> _intestazioni = {'Content-Type': 'application/json'};

  static dynamic _analizzaRisposta(http.Response risposta) {
    final decodificato = jsonDecode(risposta.body);
    if (decodificato is Map && decodificato.containsKey('dati')) {
      return decodificato['dati'];
    }
    return decodificato;
  }

  static Future<List<Genere>> ottieniGeneri() async {
    final risposta = await http
        .get(Uri.parse('$urlBase/generi'))
        .timeout(_timeout);
    final dati = _analizzaRisposta(risposta);
    return (dati as List).map((e) => Genere.daJson(e as Map<String, dynamic>)).toList();
  }

  static Future<Genere> creaGenere(Genere genere) async {
    final risposta = await http
        .post(Uri.parse('$urlBase/generi'), headers: _intestazioni, body: jsonEncode(genere.aJson()))
        .timeout(_timeout);
    return Genere.daJson(_analizzaRisposta(risposta) as Map<String, dynamic>);
  }

  static Future<Genere> aggiornaGenere(int id, Genere genere) async {
    final risposta = await http
        .put(Uri.parse('$urlBase/generi/$id'), headers: _intestazioni, body: jsonEncode(genere.aJson()))
        .timeout(_timeout);
    return Genere.daJson(_analizzaRisposta(risposta) as Map<String, dynamic>);
  }

  static Future<Genere> aggiornaParzialmenteGenere(int id, Map<String, dynamic> campi) async {
    final risposta = await http
        .patch(Uri.parse('$urlBase/generi/$id'), headers: _intestazioni, body: jsonEncode(campi))
        .timeout(_timeout);
    return Genere.daJson(_analizzaRisposta(risposta) as Map<String, dynamic>);
  }

  static Future<void> eliminaGenere(int id) async {
    await http.delete(Uri.parse('$urlBase/generi/$id')).timeout(_timeout);
  }

  static Future<List<Film>> ottienFilm({int? genereId, String? stato}) async {
    final parametri = <String, String>{};
    if (genereId != null) parametri['genere_id'] = genereId.toString();
    if (stato    != null) parametri['stato']      = stato;

    final uri = Uri.parse('$urlBase/film').replace(
      queryParameters: parametri.isNotEmpty ? parametri : null,
    );
    final risposta = await http.get(uri).timeout(_timeout);
    final dati = _analizzaRisposta(risposta);
    return (dati as List).map((e) => Film.daJson(e as Map<String, dynamic>)).toList();
  }

  static Future<Film> ottieniFilm(int id) async {
    final risposta = await http
        .get(Uri.parse('$urlBase/film/$id'))
        .timeout(_timeout);
    return Film.daJson(_analizzaRisposta(risposta) as Map<String, dynamic>);
  }

  static Future<Film> creaFilm(Film film) async {
    final risposta = await http
        .post(Uri.parse('$urlBase/film'), headers: _intestazioni, body: jsonEncode(film.aJson()))
        .timeout(_timeout);
    return Film.daJson(_analizzaRisposta(risposta) as Map<String, dynamic>);
  }

  static Future<Film> aggiornaFilm(int id, Film film) async {
    final risposta = await http
        .put(Uri.parse('$urlBase/film/$id'), headers: _intestazioni, body: jsonEncode(film.aJson()))
        .timeout(_timeout);
    return Film.daJson(_analizzaRisposta(risposta) as Map<String, dynamic>);
  }

  static Future<Film> aggiornaParzialmenteFilm(int id, Map<String, dynamic> campi) async {
    final risposta = await http
        .patch(Uri.parse('$urlBase/film/$id'), headers: _intestazioni, body: jsonEncode(campi))
        .timeout(_timeout);
    return Film.daJson(_analizzaRisposta(risposta) as Map<String, dynamic>);
  }

  static Future<void> eliminaFilm(int id) async {
    await http.delete(Uri.parse('$urlBase/film/$id')).timeout(_timeout);
  }
}
