type t =
| Petit_Roque
| Grand_Roque
| Arrivee of Jeu.Piece.ptype * (int * int)
| Placement of Jeu.Piece.ptype * (int * int)
| Ambigu of int*string * Jeu.Piece.ptype * (int * int)

val to_string : t -> string
val from_string : string -> t option
