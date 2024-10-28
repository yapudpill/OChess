open EntreeSortie.Algebrique

open TestUtil

(*** Test de la notation algébrique ***)
let test_to_algebrique coup attendu =
  Alcotest.(check string) (string_of_coup coup) attendu (to_algebrique coup)

let test_to_mouvement () =
  test_to_algebrique (Mouvement (Roi, (2, 2)))      "Rc3";
  test_to_algebrique (Mouvement (Dame, (6, 1)))     "Dg2";
  test_to_algebrique (Mouvement (Cavalier, (0, 0))) "Ca1";
  test_to_algebrique (Mouvement (Tour, (7, 1)))     "Th2";
  test_to_algebrique (Mouvement (Fou, (5, 3)))      "Ff4";
  test_to_algebrique (Mouvement (Pion, (7, 7)))     "Ph8"

let test_to_roque () =
  test_to_algebrique Grand_roque "O-O-O";
  test_to_algebrique Petit_roque "O-O"

let test_to = [
  "Mouvement", `Quick, test_to_mouvement;
  "Roque",     `Quick, test_to_roque
]

let test_from_algebrique str attendu =
  Alcotest.(check (option coup)) str attendu (from_algebrique str)

let test_from_mouvement () =
  test_from_algebrique "Rc3" (Some (Mouvement (Roi, (2, 2))));
  test_from_algebrique "Dg2" (Some (Mouvement (Dame, (6, 1))));
  test_from_algebrique "Ca1" (Some (Mouvement (Cavalier, (0, 0))));
  test_from_algebrique "Th2" (Some (Mouvement (Tour, (7, 1))));
  test_from_algebrique "Ff4" (Some (Mouvement (Fou, (5, 3))));
  test_from_algebrique "Ph8" (Some (Mouvement (Pion, (7, 7))));
  test_from_algebrique "h8" (Some (Mouvement (Pion, (7, 7))))

let test_from_roque () =
  test_from_algebrique "O-O-O" (Some Grand_roque);
  test_from_algebrique "o-o-o" (Some Grand_roque);
  test_from_algebrique "O-O" (Some Petit_roque);
  test_from_algebrique "o-o" (Some Petit_roque)

let test_from_invalide () =
  test_from_algebrique "" None;
  test_from_algebrique "Ch10" None;
  test_from_algebrique "Fc9" None;
  test_from_algebrique "Tk0" None;
  test_from_algebrique "Gk0" None

let test_from = [
  "Mouvement", `Quick, test_from_mouvement;
  "Roque",     `Quick, test_from_roque;
  "Invalide",  `Quick, test_from_invalide
]


(*** Lancement des tests ***)
let () = Alcotest.run "Algébrique" [
  "Vers notation algébrique", test_to;
  "Depuis notation algébrique", test_from;
]