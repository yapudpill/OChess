(* Types de base *)
type case = Vide | Piece of Piece.t
type t = case array array

(** Initialisation d'un échiquier en position de départ *)
val init_echiquier : unit -> t

val est_adversaire : Piece.couleur -> case -> bool
val est_vide_ou_adversaire : Piece.couleur -> case -> bool
