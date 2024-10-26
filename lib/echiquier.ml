open Piece

type case = Vide | Piece of Piece.t
type t = case array array

type coup = Petit_roque | Grand_roque | Mouvement of ptype * (int * int)

(* Manipulation des échiquiers *)
let (.${}) echiquier (x, y) = echiquier.(x).(y)

let (.${}<-) echiquier (x, y) c = echiquier.(x).(y) <- c

let est_adversaire c = function
| Vide -> false
| Piece (c', _) -> c <> c'

let est_vide = function
| Vide -> true
| _ -> false

let est_vide_ou_adversaire c case = est_adversaire c case || est_vide case

let contient_case p = function
| Vide -> false
| Piece p' -> p' = p

let contient echiquier p (x, y) = contient_case p echiquier.${x, y}