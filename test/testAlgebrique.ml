open EntreeSortie.Algebrique

open TestUtil


let test_to_string coup attendu =
  Alcotest.(check string) (string_of_algebrique coup) attendu (to_string coup)

let test_to_arrivee () =
  test_to_string (Arrivee (Roi, (2, 2)))      "Rc3";
  test_to_string (Arrivee (Dame, (6, 1)))     "Dg2";
  test_to_string (Arrivee (Cavalier, (0, 0))) "Ca1";
  test_to_string (Arrivee (Tour, (7, 1)))     "Th2";
  test_to_string (Arrivee (Fou, (5, 3)))      "Ff4";
  test_to_string (Arrivee (Pion, (7, 7)))     "Ph8"

let test_to_roque () =
  test_to_string Grand_Roque "O-O-O";
  test_to_string Petit_Roque "O-O"

let test_to_placement () =
  test_to_string (Placement (Fou, (5, 3)))  "@Ff4";
  test_to_string (Placement (Pion, (7, 7))) "@Ph8"

let test_to = [
  "Mouvement", `Quick, test_to_arrivee;
  "Roque",     `Quick, test_to_roque;
  "Placement", `Quick, test_to_placement
]


let test_from_string str attendu =
  Alcotest.(check (option algebrique)) str attendu (from_string str)

let test_from_arrivee () =
  test_from_string "Rc3" (Some (Arrivee (Roi, (2, 2))));
  test_from_string "Dg2" (Some (Arrivee (Dame, (6, 1))));
  test_from_string "ca1" (Some (Arrivee (Cavalier, (0, 0))));
  test_from_string "tH2" (Some (Arrivee (Tour, (7, 1))));
  test_from_string "FF4" (Some (Arrivee (Fou, (5, 3))));
  test_from_string "PH8" (Some (Arrivee (Pion, (7, 7))));
  test_from_string "h8"  (Some (Arrivee (Pion, (7, 7))))

let test_from_roque () =
  test_from_string "O-O-O" (Some Grand_Roque);
  test_from_string "o-o-o" (Some Grand_Roque);
  test_from_string "O-O"   (Some Petit_Roque);
  test_from_string "o-o"   (Some Petit_Roque)

let test_from_placement () =
  test_from_string "@Ff4" (Some (Placement (Fou, (5, 3))));
  test_from_string "@pH8" (Some (Placement (Pion, (7, 7))));
  test_from_string "@h8"  (Some (Placement (Pion, (7, 7))))

let test_from_invalide () =
  test_from_string ""     None;
  test_from_string "Ch10" None;
  test_from_string "@Ch10" None;
  test_from_string "Fc9"  None;
  test_from_string "Tk0"  None;
  test_from_string "Gk0"  None

let test_from = [
  "Mouvement", `Quick, test_from_arrivee;
  "Roque",     `Quick, test_from_roque;
  "Placement", `Quick, test_from_placement;
  "Invalide",  `Quick, test_from_invalide
]


let () = Alcotest.run "Algébrique" [
  "Vers notation algébrique", test_to;
  "Depuis notation algébrique", test_from;
]