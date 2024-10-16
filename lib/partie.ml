type t = {
  echiquier : Echiquier.t;
  trait : Piece.couleur;
  roi_blanc : int * int;
  roi_noir : int * int;
}

let init_partie () = {
  echiquier = Echiquier.init_echiquier ();
  trait = Piece.Blanc;
  roi_blanc = (4, 0);
  roi_noir = (4, 7);
}

let pos_roi partie = function
| Piece.Blanc -> partie.roi_blanc
| Piece.Noir -> partie.roi_noir