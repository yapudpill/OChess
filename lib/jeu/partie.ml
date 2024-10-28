type t = {
  echiquier : Echiquier.t;
  trait : Piece.couleur;
  roi_blanc : int * int;
  roi_noir : int * int;
  roque_blanc : bool * bool;
  roque_noir : bool * bool;
  prise_en_passant : (int*int) option;
}

let get_pos_roi partie = function
| Piece.Blanc -> partie.roi_blanc
| Piece.Noir -> partie.roi_noir

let get_roque partie = function
| Piece.Blanc -> partie.roque_blanc
| Piece.Noir -> partie.roque_noir

let set_pos_roi couleur arr partie = match couleur with
| Piece.Blanc -> {partie with roi_blanc = arr; roque_blanc = (false, false)}
| Piece.Noir  -> {partie with roi_noir = arr; roque_noir = (false, false)}

let set_roque couleur roque partie = match couleur with
| Piece.Blanc -> {partie with roque_blanc = roque}
| Piece.Noir  -> {partie with roque_noir  = roque}

let peut_roquer_sans_echec partie type_roque =
  let (g, p) = get_roque partie partie.trait in
  if type_roque = 1 then p else g
