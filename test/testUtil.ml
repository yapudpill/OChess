open Jeu.Piece

(*** Conversion en string ***)
let string_of_couleur = function
| Blanc -> "Blanc"
| Noir -> "Noir"

let string_of_ptype = function
| Pion -> "Pion"
| Cavalier -> "Cavalier"
| Fou -> "Fou"
| Tour -> "Tour"
| Dame -> "Dame"
| Roi -> "Roi"

let string_of_piece = function
| (Blanc, Pion) -> "Pion blanc"
| (Blanc, Cavalier) -> "Cavalier blanc"
| (Blanc, Fou) -> "Fou blanc"
| (Blanc, Roi) -> "Roi blanc"
| (Blanc, Tour) -> "Tour blanche"
| (Blanc, Dame) -> "Dame blanche"

| (Noir, Pion) -> "Pion noir"
| (Noir, Cavalier) -> "Cavalier noir"
| (Noir, Fou) -> "Fou noir"
| (Noir, Roi) -> "Roi noir"
| (Noir, Tour) -> "Tour noire"
| (Noir, Dame) -> "Dame noire"

let string_of_algebrique =
  let open EntreeSortie.Algebrique in
  function
  | Grand_Roque -> "Grand roque"
  | Petit_Roque -> "Petit roque"
  | Arrivee (p, (x, y)) -> Printf.sprintf "%s (%d, %d)" (string_of_ptype p) x y
  | Placement (p, (x, y)) -> Printf.sprintf "@%s (%d, %d)" (string_of_ptype p) x y

let string_of_coup =
  let open Jeu.Partie in
  function
  | Grand_Roque -> "Grand roque"
  | Petit_Roque -> "Petit roque"
  | Mouvement ((x, y), (x', y')) -> Printf.sprintf "(%d, %d) -> (%d, %d)" x y x' y'
  | Placement (p, (x, y)) -> Printf.sprintf "@%s (%d, %d)" (string_of_ptype p) x y

let string_of_erreur =
  let open Jeu.Partie in
  function
  | Invalide -> "Invalide"
  | Ambigu l  ->
    Printf.sprintf "Ambigu : %s" Fmt.((to_to_string @@ Dump.list (Dump.pair int int)) l)


(*** Testables ***)
let mouv_list = Alcotest.(slist (pair int int) compare)
let mouv_list_list = Alcotest.slist mouv_list compare
let couleur = Alcotest.of_pp (Fmt.of_to_string string_of_couleur)
let ptype = Alcotest.of_pp (Fmt.of_to_string string_of_ptype)
let case = Alcotest.(option @@ pair couleur ptype)
let algebrique = Alcotest.of_pp (Fmt.of_to_string string_of_algebrique)
let coup = Alcotest.of_pp (Fmt.of_to_string string_of_coup)
let erreur = Alcotest.of_pp (Fmt.of_to_string string_of_erreur)