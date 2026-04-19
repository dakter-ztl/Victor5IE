<?php

class ControllerFilm {
    private PDO $connessione;

    private const STATI_VALIDI = ['da_vedere', 'in_corso', 'visto'];

    public function __construct() {
        $this->connessione = Database::getInstance()->getConnessione();
    }

    public function lista(): void {
        $sql       = "SELECT f.*, g.nome AS nome_genere, g.colore AS colore_genere
                      FROM film f
                      LEFT JOIN generi g ON f.genere_id = g.id
                      WHERE 1=1";
        $parametri = [];

        if (!empty($_GET['genere_id']) && ctype_digit($_GET['genere_id'])) {
            $sql        .= " AND f.genere_id = ?";
            $parametri[] = (int)$_GET['genere_id'];
        }
        if (!empty($_GET['stato']) && in_array($_GET['stato'], self::STATI_VALIDI)) {
            $sql        .= " AND f.stato = ?";
            $parametri[] = $_GET['stato'];
        }
        $sql .= " ORDER BY f.titolo";

        $istruzione = $this->connessione->prepare($sql);
        $istruzione->execute($parametri);
        Risposta::successo($istruzione->fetchAll());
    }

    public function dettaglio(int $id): void {
        $istruzione = $this->connessione->prepare(
            "SELECT f.*, g.nome AS nome_genere, g.colore AS colore_genere
             FROM film f
             LEFT JOIN generi g ON f.genere_id = g.id
             WHERE f.id = ?"
        );
        $istruzione->execute([$id]);
        $film = $istruzione->fetch();
        if (!$film) {
            Risposta::errore("Film con id={$id} non trovato", 404);
        }
        Risposta::successo($film);
    }

    public function crea(array $dati): void {
        if (empty($dati['titolo'])) {
            Risposta::errore("Il campo 'titolo' è obbligatorio");
        }
        [$stato, $valutazione] = $this->normalizzaStatoValutazione($dati);

        $istruzione = $this->connessione->prepare(
            "INSERT INTO film (titolo, anno, regista, genere_id, url_locandina, stato, valutazione, recensione)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
        );
        $istruzione->execute([
            trim($dati['titolo']),
            isset($dati['anno'])          ? (int)$dati['anno']              : null,
            isset($dati['regista'])       ? trim($dati['regista'])          : null,
            isset($dati['genere_id'])     ? (int)$dati['genere_id']         : null,
            isset($dati['url_locandina']) ? trim($dati['url_locandina'])    : null,
            $stato,
            $valutazione,
            isset($dati['recensione'])    ? trim($dati['recensione'])       : null,
        ]);
        $this->dettaglio((int)$this->connessione->lastInsertId());
    }

    public function aggiorna(int $id, array $dati): void {
        if (empty($dati['titolo'])) {
            Risposta::errore("Il campo 'titolo' è obbligatorio");
        }
        [$stato, $valutazione] = $this->normalizzaStatoValutazione($dati);

        $istruzione = $this->connessione->prepare(
            "UPDATE film
             SET titolo=?, anno=?, regista=?, genere_id=?, url_locandina=?, stato=?, valutazione=?, recensione=?
             WHERE id=?"
        );
        $istruzione->execute([
            trim($dati['titolo']),
            isset($dati['anno'])          ? (int)$dati['anno']           : null,
            isset($dati['regista'])       ? trim($dati['regista'])       : null,
            isset($dati['genere_id'])     ? (int)$dati['genere_id']      : null,
            isset($dati['url_locandina']) ? trim($dati['url_locandina']) : null,
            $stato,
            $valutazione,
            isset($dati['recensione'])    ? trim($dati['recensione'])    : null,
            $id,
        ]);

        if ($istruzione->rowCount() === 0) {
            $verifica = $this->connessione->prepare("SELECT id FROM film WHERE id = ?");
            $verifica->execute([$id]);
            if (!$verifica->fetch()) {
                Risposta::errore("Film con id={$id} non trovato", 404);
            }
        }
        $this->dettaglio($id);
    }

    public function aggiornaParziale(int $id, array $dati): void {
        if (empty($dati)) {
            Risposta::errore("Nessun campo da aggiornare nel corpo della richiesta");
        }

        $campiConsentiti = ['titolo', 'anno', 'regista', 'genere_id', 'url_locandina', 'stato', 'valutazione', 'recensione'];
        $campi           = [];
        $parametri       = [];

        foreach ($campiConsentiti as $campo) {
            if (!array_key_exists($campo, $dati)) continue;

            if ($campo === 'stato' && !in_array($dati[$campo], self::STATI_VALIDI)) {
                Risposta::errore("Valore non valido per 'stato'. Valori ammessi: " . implode(', ', self::STATI_VALIDI));
            }
            if ($campo === 'valutazione' && $dati[$campo] !== null) {
                $valore = (int)$dati[$campo];
                if ($valore < 1 || $valore > 5) {
                    Risposta::errore("La valutazione deve essere compresa tra 1 e 5");
                }
                $dati[$campo] = $valore;
            }

            $campi[]     = "{$campo} = ?";
            $parametri[] = $dati[$campo];
        }

        if (empty($campi)) {
            Risposta::errore("Nessun campo valido da aggiornare");
        }

        $parametri[] = $id;
        $sql         = "UPDATE film SET " . implode(', ', $campi) . " WHERE id = ?";
        $istruzione  = $this->connessione->prepare($sql);
        $istruzione->execute($parametri);

        if ($istruzione->rowCount() === 0) {
            $verifica = $this->connessione->prepare("SELECT id FROM film WHERE id = ?");
            $verifica->execute([$id]);
            if (!$verifica->fetch()) {
                Risposta::errore("Film con id={$id} non trovato", 404);
            }
        }
        $this->dettaglio($id);
    }

    public function elimina(int $id): void {
        $istruzione = $this->connessione->prepare("DELETE FROM film WHERE id = ?");
        $istruzione->execute([$id]);
        if ($istruzione->rowCount() === 0) {
            Risposta::errore("Film con id={$id} non trovato", 404);
        }
        Risposta::successo(null, "Film eliminato con successo");
    }

    private function normalizzaStatoValutazione(array $dati): array {
        $stato = in_array($dati['stato'] ?? '', self::STATI_VALIDI)
            ? $dati['stato']
            : 'da_vedere';

        $valutazione = null;
        if (isset($dati['valutazione']) && $dati['valutazione'] !== null) {
            $valore = (int)$dati['valutazione'];
            if ($valore >= 1 && $valore <= 5) {
                $valutazione = $valore;
            }
        }
        return [$stato, $valutazione];
    }
}
