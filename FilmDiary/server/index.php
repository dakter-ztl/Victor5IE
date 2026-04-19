<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once __DIR__ . '/config/database.php';
require_once __DIR__ . '/helpers/Risposta.php';
require_once __DIR__ . '/controllers/ControllerGeneri.php';
require_once __DIR__ . '/controllers/ControllerFilm.php';

$metodo = $_SERVER['REQUEST_METHOD'];

$uri      = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$uri      = preg_replace('#^.*?/server#', '', $uri);
$uri      = trim($uri, '/');
$segmenti = explode('/', $uri);
$risorsa  = $segmenti[0] ?? '';
$id       = (isset($segmenti[1]) && ctype_digit($segmenti[1])) ? (int)$segmenti[1] : null;
$corpo = json_decode(file_get_contents('php://input'), true) ?? [];
try {
    switch ($risorsa) {

        case 'generi':
            $controllore = new ControllerGeneri();
            match (true) {
                $metodo === 'GET'    && $id === null => $controllore->lista(),
                $metodo === 'GET'                    => $controllore->dettaglio($id),
                $metodo === 'POST'                   => $controllore->crea($corpo),
                $metodo === 'PUT'   && $id !== null  => $controllore->aggiorna($id, $corpo),
                $metodo === 'PATCH' && $id !== null  => $controllore->aggiornaParziale($id, $corpo),
                $metodo === 'DELETE'&& $id !== null  => $controllore->elimina($id),
                default                              => Risposta::errore("Metodo o route non supportato", 405),
            };
            break;

        case 'film':
            $controllore = new ControllerFilm();
            match (true) {
                $metodo === 'GET'    && $id === null => $controllore->lista(),
                $metodo === 'GET'                    => $controllore->dettaglio($id),
                $metodo === 'POST'                   => $controllore->crea($corpo),
                $metodo === 'PUT'   && $id !== null  => $controllore->aggiorna($id, $corpo),
                $metodo === 'PATCH' && $id !== null  => $controllore->aggiornaParziale($id, $corpo),
                $metodo === 'DELETE'&& $id !== null  => $controllore->elimina($id),
                default                              => Risposta::errore("Metodo o route non supportato", 405),
            };
            break;

        default:
            Risposta::errore("Risorsa '{$risorsa}' non trovata", 404);
    }
} catch (PDOException $erroreDb) {
    Risposta::errore("Errore database: " . $erroreDb->getMessage(), 500);
} catch (Throwable $errore) {
    Risposta::errore("Errore interno: " . $errore->getMessage(), 500);
}
