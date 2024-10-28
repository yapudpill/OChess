val string_of_couleur : Piece.couleur -> string
val char_of_piece : Piece.ptype -> char
val piece_of_char : char -> Piece.ptype option
val print_echiquier : ?couleur:bool -> Echiquier.t -> unit
