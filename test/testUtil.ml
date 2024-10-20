open Alcotest

open OChess
open Piece

let mouv_list = slist (pair int int) compare

let nom_piece = function
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