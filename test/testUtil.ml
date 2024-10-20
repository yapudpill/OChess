open OChess
open Piece

let mouv_list = Alcotest.(slist (pair int int) compare)

let mouv_list_list = Alcotest.slist mouv_list compare

let string_of_couleur = function
| Blanc -> "Blanc"
| Noir -> "Noir"

let couleur = Alcotest.of_pp (Fmt.of_to_string string_of_couleur)

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