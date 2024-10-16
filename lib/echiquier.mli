(* Types de base *)
type case = Vide | Piece of Piece.t
type t = case array array

(** Initialisation d'un échiquier en position de départ *)
val init_echiquier : unit -> t

(* Accès/modificaton d'échiquier *)
val (.${}) : t -> int * int -> case
val (.${}<-) : t -> int * int -> case -> unit

val est_vide_ou_adversaire : Piece.couleur -> case -> bool
val contient : Piece.t -> t -> int * int -> bool