(* Notation algébrique *)
val to_algebrique : Piece.ptype -> int * int -> string
val from_algebrique : string -> Echiquier.coup


(* Échiquier *)
val string_of_echiquier : ?couleur:bool -> Echiquier.t -> string
val char_of_piece : Piece.ptype -> char
