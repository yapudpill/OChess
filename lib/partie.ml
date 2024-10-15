type t = {
  echiquier : Echiquier.t;
  trait : Piece.couleur;
}

let init_partie () = {
  echiquier = Echiquier.init_echiquier ();
  trait = Piece.Blanc;
}