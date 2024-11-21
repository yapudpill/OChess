val creer_partie_fen : string -> Jeu.Partie.t
(** Initialise une partie d'échecs à partir d'une chaîne au format FEN (Forsyth-Edwards Notation).

    @param fen Une chaîne représentant l'état initial de la partie selon la notation FEN.
               Cette chaîne doit contenir au minimum :
               - La position des pièces sur l'échiquier.
               - Le trait (qui doit jouer).
               - Les droits de roque.
    @return Une valeur de type [Jeu.Partie.t] représentant l'état initial de la partie. *)
