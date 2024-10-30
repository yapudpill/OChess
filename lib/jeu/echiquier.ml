type case = Piece.t option
type t = case array array

(* Manipulation des échiquiers *)
let (.${}) echiquier (x, y) = echiquier.(x).(y)

let (.${}<-) echiquier (x, y) c = echiquier.(x).(y) <- c

let est_adversaire c = Option.fold ~none:false ~some:(fun (c', _) -> c <> c')

let est_vide = Option.is_none

let est_vide_ou_adversaire c case = est_adversaire c case || est_vide case

let contient_case p = Option.fold ~none:false ~some:((=) p)

let contient echiquier p (x, y) = contient_case p echiquier.${x, y}