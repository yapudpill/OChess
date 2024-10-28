val string_of_couleur : Jeu.Piece.couleur -> string
val char_of_piece : Jeu.Piece.ptype -> char
val piece_of_char : char -> Jeu.Piece.ptype option
val print_echiquier : ?couleur:bool -> Jeu.Echiquier.t -> unit
