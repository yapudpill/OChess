val string_of_couleur : Jeu.Piece.couleur -> string
(** Convertit une couleur en chaîne de caractères.
    @param couleur La couleur à convertir (Blanc ou Noir).
    @return Une chaîne de caractères représentant la couleur :
            - "Blanc" pour [Jeu.Piece.Blanc]
            - "Noir" pour [Jeu.Piece.Noir]. *)

val char_of_piece : Jeu.Piece.ptype -> char
(** Convertit un type de pièce en un caractère.
    @param ptype Le type de pièce à convertir ([Roi], [Dame], [Fou], [Tour], [Cavalier], [Pion]).
    @return Un caractère unique représentant la pièce :
            - 'K' pour [Roi]
            - 'Q' pour [Dame]
            - 'B' pour [Fou]
            - 'R' pour [Tour]
            - 'N' pour [Cavalier]
            - 'P' pour [Pion]. *)


val piece_of_char : char -> Jeu.Piece.ptype option
(** Convertit un caractère en un type de pièce, si valide.
    @param c Le caractère à convertir.
    @return [Some ptype] si le caractère correspond à un type de pièce valide :
            - 'K', 'Q', 'B', 'R', 'N', 'P' pour les pièces respectives.
            [None] si le caractère ne correspond à aucune pièce. *)


val print_echiquier : ?couleur:bool -> Jeu.Echiquier.t -> unit
(** Affiche l'échiquier dans la console.
    @param couleur (optionnel) Si [true], l'échiquier est affiché avec les couleurs des cases.
                    Par défaut, cet argument est [false].
    @param echiquier L'échiquier à afficher. *)
