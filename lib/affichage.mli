(* Notation algébrique *)
val to_algebrique : Piece.ptype -> int * int -> string
val from_algebrique : string -> Piece.ptype * (int * int)


(* Échiquier *)
val string_of_echiquier : ?couleur:bool -> Echiquier.t -> string
