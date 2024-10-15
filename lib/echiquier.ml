open Piece

type case = Vide | Piece of Piece.t
type t = case array array

let est_adversaire c = function
| Vide -> false
| Piece (c', _) -> c = c'

let est_vide_ou_adversaire c = function
| Vide -> true
| Piece (c', _) -> c = c'

let init_pos x y =
  let arriere = function
  | 0 | 7 -> Tour
  | 1 | 6 -> Cavalier
  | 2 | 5 -> Fou
  | 3 -> Dame
  | 4 -> Roi
  | _ -> invalid_arg "init"
  in

  if 1 < y && y < 6 then Vide
  else
    let c = if y <= 1 then Blanc else Noir in
    let p = if y = 1 || y = 6 then Pion else arriere x in
    Piece (c, p)

let init_echiquier () = Array.init_matrix 8 8 init_pos