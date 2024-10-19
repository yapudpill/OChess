type t = {
  echiquier : Echiquier.t;
  trait : Piece.couleur;
  roi_blanc : int * int;
  roi_noir : int * int;
  roque_blanc : bool*bool*bool;
  roque_noir : bool*bool*bool;
}
val init_partie : unit -> t
val pos_roi : t -> Piece.couleur -> int * int
val peut_roquer_sans_echec : t -> int -> bool