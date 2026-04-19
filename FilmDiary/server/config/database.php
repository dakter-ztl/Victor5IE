<?php
// pdo singleton per connessione al database
class Database {
    private static ?Database $istanza = null;
    private PDO $connessione;

    private string $host     = 'localhost';
    private string $nomeDb   = 'filmdiary';
    private string $utente   = 'root';
    private string $password = '';
    private string $charset  = 'utf8mb4';

    private function __construct() {
        $sorgente  = "mysql:host={$this->host};dbname={$this->nomeDb};charset={$this->charset}";
        $opzioni   = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        $this->connessione = new PDO($sorgente, $this->utente, $this->password, $opzioni);
    }

    public static function getInstance(): Database {
        if (self::$istanza === null) {
            self::$istanza = new Database();
        }
        return self::$istanza;
    }

    public function getConnessione(): PDO {
        return $this->connessione;
    }
}
