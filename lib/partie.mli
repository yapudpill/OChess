type t = {
  echiquier : Echiquier.t;
  trait : Piece.couleur;
  roi_blanc : int * int;
  roi_noir : int * int;
}
val init_partie : unit -> t
val pos_roi : t -> Piece.couleur -> int * int