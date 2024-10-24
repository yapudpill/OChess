open Piece

type case = Vide | Piece of Piece.t
type t = case array array

type coup = | Petit_roque | Grand_roque | Mouvement of ptype*(int*int)

(* Initialisation d'un échiquier *)
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

(* Manipulation des échiquiers *)
let (.${}) echiquier (x, y) = echiquier.(x).(y)

let (.${}<-) echiquier (x, y) c = echiquier.(x).(y) <- c

let est_adversaire c = function
| Vide -> false
| Piece (c', _) -> c <> c'

let est_vide = function
| Vide -> true | _ -> false
let est_vide_ou_adversaire c case=
    est_adversaire c case || est_vide case


let contient_case p = function
| Vide -> false
| Piece p' -> p' = p

let contient echiquier p (x, y) = contient_case p echiquier.${x, y}