type t = {
  echiquier : Echiquier.t;
  trait : Piece.couleur;
  roi_blanc : int * int;
  roi_noir : int * int;
  roque_blanc : bool*bool*bool;
  roque_noir : bool*bool*bool;
}

let init_partie () = {
  echiquier = Echiquier.init_echiquier ();
  trait = Piece.Blanc;
  roi_blanc = (4, 0);
  roi_noir = (4, 7);
  roque_blanc = (true,true,true);
  roque_noir = (true,true,true);
}

let pos_roi partie = function
| Piece.Blanc -> partie.roi_blanc
| Piece.Noir -> partie.roi_noir

let peut_roquer_sans_echec partie type_roque =
  let tg,r,td = match partie.trait with | Blanc -> partie.roque_blanc | _ -> partie.roque_noir
  in if type_roque = 1 then r&&td else tg&&r
