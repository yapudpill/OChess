type t = {
  echiquier : Echiquier.t;
  trait : Piece.couleur;
  roi_blanc : int * int;
  roi_noir : int * int;
  roque_blanc : bool*bool;
  roque_noir : bool*bool;
}

let pos_roi partie = function
| Piece.Blanc -> partie.roi_blanc
| Piece.Noir -> partie.roi_noir

let peut_roquer_sans_echec partie type_roque =
  let g,p = match partie.trait with | Blanc -> partie.roque_blanc | Noir -> partie.roque_noir
  in if type_roque = 1 then p else g
