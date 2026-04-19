<?php

class Risposta {

    public static function json(mixed $dati, int $stato = 200): never {
        http_response_code($stato);
        echo json_encode($dati, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
        exit;
    }

    public static function successo(mixed $dati, string $messaggio = 'OK', int $stato = 200): never {
        self::json([
            'successo'  => true,
            'messaggio' => $messaggio,
            'dati'      => $dati,
        ], $stato);
    }

    public static function errore(string $messaggio, int $stato = 400): never {
        self::json([
            'successo'  => false,
            'messaggio' => $messaggio,
            'dati'      => null,
        ], $stato);
    }
}
