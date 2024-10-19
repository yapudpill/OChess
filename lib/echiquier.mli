(* Types de base *)
type case = Vide | Piece of Piece.t
type t = case array array
type coup = | Petit_roque | Grand_roque | Mouvement of Piece.ptype*(int*int)


(** Initialisation d'un échiquier en position de départ *)
val init_echiquier : unit -> t

(* Accès/modificaton d'échiquier *)
val (.${}) : t -> int * int -> case
val (.${}<-) : t -> int * int -> case -> unit

val est_adversaire : Piece.couleur -> case -> bool
val est_vide_ou_adversaire : Piece.couleur -> case -> bool
val contient : Piece.t -> t -> int * int -> bool
val est_vide : case -> bool