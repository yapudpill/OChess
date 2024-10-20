open Printf

open OChess
open Piece

open TestUtil

(** Fonction générique pour tester une pièce.

[test_piece p x y l] vérifie que les mouvements possibles de la piece [p] en
partant de [(x, y)] sont bien [l]. *)
let test_piece p x y l =
  Alcotest.check mouv_list (sprintf "%s depuis (%d, %d)" (nom_piece p) x y) (mouvement p (x, y)) l


(* Pion depuis toutes les cases possibles *)
let pion_blanc_normal () =
  for y = 2 to 6 do
    test_piece (Blanc, Pion) 0 y [(0, y+1); (1, y+1)];
    test_piece (Blanc, Pion) 7 y [(7, y+1); (6, y+1)];
    for x = 1 to 6 do
      test_piece (Blanc, Pion) x y [(x, y+1); (x-1, y+1); (x+1, y+1)]
    done
  done

let pion_blanc_depart () =
  test_piece (Blanc, Pion) 0 1 [(0, 2); (0, 3); (1, 2)];
  test_piece (Blanc, Pion) 7 1 [(7, 2); (7, 3); (6, 2)];
  for x = 1 to 6 do
    test_piece (Blanc, Pion) x 1 [(x, 2); (x, 3); (x-1, 2); (x+1, 2)]
  done

let pion_noir_normal () =
  for y = 1 to 5 do
    test_piece (Noir, Pion) 0 y [(0, y-1); (1, y-1)];
    test_piece (Noir, Pion) 7 y [(7, y-1); (6, y-1)];
    for x = 1 to 6 do
      test_piece (Noir, Pion) x y [(x, y-1); (x-1, y-1); (x+1, y-1)]
    done
  done

let pion_noir_depart () =
  test_piece (Noir, Pion) 0 6 [(0, 5); (0, 4); (1, 5)];
  test_piece (Noir, Pion) 7 6 [(7, 5); (7, 4); (6, 5)];
  for x = 1 to 6 do
    test_piece (Noir, Pion) x 6 [(x, 5); (x, 4); (x-1, 5); (x+1, 5)]
  done

let test_pion = [
  ("Blanc départ", `Quick, pion_blanc_depart);
  ("Blanc normal", `Quick, pion_blanc_normal);
  ("Noir départ", `Quick, pion_noir_depart);
  ("Noir normal", `Quick, pion_noir_normal);
]



let () = Alcotest.run "Piece" [
  "Pion", test_pion
]