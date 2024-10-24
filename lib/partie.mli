type t = {
  echiquier : Echiquier.t;
  trait : Piece.couleur;
  roi_blanc : int * int;
  roi_noir : int * int;
  roque_blanc : bool * bool;
  roque_noir : bool * bool;
}

val peut_roquer_sans_echec : t -> int -> bool
val get_pos_roi : t -> Piece.couleur -> int * int
val get_roque : t -> Piece.couleur -> bool * bool
val set_pos_roi : Piece.couleur -> int * int -> t -> t
val set_roque : Piece.couleur -> bool * bool -> t -> t
