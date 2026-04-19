<?php
class ControllerGeneri {
    private PDO $connessione;

    public function __construct() {
        $this->connessione = Database::getInstance()->getConnessione();
    }

    public function lista(): void {
        $istruzione = $this->connessione->query("SELECT * FROM generi ORDER BY nome");
        Risposta::successo($istruzione->fetchAll());
    }

    public function dettaglio(int $id): void {
        $istruzione = $this->connessione->prepare("SELECT * FROM generi WHERE id = ?");
        $istruzione->execute([$id]);
        $genere = $istruzione->fetch();
        if (!$genere) {
            Risposta::errore("Genere con id={$id} non trovato", 404);
        }
        Risposta::successo($genere);
    }

    public function crea(array $dati): void {
        if (empty($dati['nome'])) {
            Risposta::errore("Il campo 'nome' è obbligatorio");
        }
        $nome   = trim($dati['nome']);
        $colore = isset($dati['colore']) && preg_match('/^#[0-9A-Fa-f]{6}$/', $dati['colore'])
            ? $dati['colore']
            : '#607D8B';

        $istruzione = $this->connessione->prepare("INSERT INTO generi (nome, colore) VALUES (?, ?)");
        $istruzione->execute([$nome, $colore]);
        $this->dettaglio((int)$this->connessione->lastInsertId());
    }

    public function aggiorna(int $id, array $dati): void {
        if (empty($dati['nome'])) {
            Risposta::errore("Il campo 'nome' è obbligatorio");
        }
        $nome   = trim($dati['nome']);
        $colore = isset($dati['colore']) && preg_match('/^#[0-9A-Fa-f]{6}$/', $dati['colore'])
            ? $dati['colore']
            : '#607D8B';

        $istruzione = $this->connessione->prepare("UPDATE generi SET nome = ?, colore = ? WHERE id = ?");
        $istruzione->execute([$nome, $colore, $id]);

        if ($istruzione->rowCount() === 0) {
            $verifica = $this->connessione->prepare("SELECT id FROM generi WHERE id = ?");
            $verifica->execute([$id]);
            if (!$verifica->fetch()) {
                Risposta::errore("Genere con id={$id} non trovato", 404);
            }
        }
        $this->dettaglio($id);
    }

    public function aggiornaParziale(int $id, array $dati): void {
        if (empty($dati)) {
            Risposta::errore("Nessun campo da aggiornare nel corpo della richiesta");
        }

        $campiConsentiti = ['nome', 'colore'];
        $campi           = [];
        $parametri       = [];

        foreach ($campiConsentiti as $campo) {
            if (!array_key_exists($campo, $dati)) continue;
            if ($campo === 'colore' && !preg_match('/^#[0-9A-Fa-f]{6}$/', $dati[$campo])) continue;
            $campi[]     = "{$campo} = ?";
            $parametri[] = $dati[$campo];
        }

        if (empty($campi)) {
            Risposta::errore("Nessun campo valido da aggiornare");
        }

        $parametri[] = $id;
        $sql         = "UPDATE generi SET " . implode(', ', $campi) . " WHERE id = ?";
        $istruzione  = $this->connessione->prepare($sql);
        $istruzione->execute($parametri);

        if ($istruzione->rowCount() === 0) {
            $verifica = $this->connessione->prepare("SELECT id FROM generi WHERE id = ?");
            $verifica->execute([$id]);
            if (!$verifica->fetch()) {
                Risposta::errore("Genere con id={$id} non trovato", 404);
            }
        }
        $this->dettaglio($id);
    }

    public function elimina(int $id): void {
        $istruzione = $this->connessione->prepare("DELETE FROM generi WHERE id = ?");
        $istruzione->execute([$id]);
        if ($istruzione->rowCount() === 0) {
            Risposta::errore("Genere con id={$id} non trovato", 404);
        }
        Risposta::successo(null, "Genere eliminato con successo");
    }
}
