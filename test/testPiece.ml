open Jeu.Piece

open TestUtil

(** Fonction générique pour tester une pièce.

[test_piece p x y l] vérifie que les mouvements possibles de la piece [p] en
partant de [(x, y)] sont bien [l]. *)
let test_piece p x y l =
  Alcotest.check mouv_list
    (Printf.sprintf "%s depuis (%d, %d)" (string_of_piece p) x y)
    l
    (mouvement p (x, y))

let test_piece_dir p x y l =
  Alcotest.check mouv_list_list
    (Printf.sprintf "%s depuis (%d, %d)" (string_of_piece p) x y)
    l
    (mouvement_dir p (x, y))

(*** Pion depuis toutes les cases possibles ***)
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

let pion_blanc_fond () =
  for x = 0 to 7 do
    test_piece (Blanc, Pion) x 7 []
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

let pion_noir_fond () =
  for x = 0 to 7 do
    test_piece (Noir, Pion) x 0 []
  done

let pion_dir () =
  test_piece_dir (Noir, Pion) 3 3 [[(3, 2)]; [(2, 2)]; [(4, 2)]]

let test_pion = [
  "Blanc départ", `Quick, pion_blanc_depart;
  "Blanc normal", `Quick, pion_blanc_normal;
  "Blanc fond",   `Quick, pion_blanc_fond;
  "Noir départ",  `Quick, pion_noir_depart;
  "Noir normal",  `Quick, pion_noir_normal;
  "Noir fond",    `Quick, pion_noir_fond;
  "Dirigé",       `Quick, pion_dir;
]


(*** Roi ***)
let roi_normal () =
  test_piece (Blanc, Roi) 4 3 [(3, 4); (4, 4); (5, 4); (3, 3); (5, 3); (3, 2); (4, 2); (5, 2)];
  test_piece (Noir, Roi)  1 6 [(0, 7); (1, 7); (2, 7); (0, 6); (2, 6); (0, 5); (1, 5); (2, 5)]

let roi_cote () =
  test_piece (Blanc, Roi) 0 1 [(0, 2); (1, 2); (1, 1); (0, 0); (1, 0)];
  test_piece (Blanc, Roi) 3 0 [(2, 1); (3, 1); (4, 1); (2, 0); (4, 0)];
  test_piece (Noir, Roi)  5 7 [(4, 7); (6, 7); (4, 6); (5, 6); (6, 6)];
  test_piece (Noir, Roi)  7 3 [(6, 4); (7, 4); (6, 3); (6, 2); (7, 2)]

let roi_coin () =
  test_piece (Blanc, Roi) 0 0 [(0, 1); (1, 1); (1, 0)];
  test_piece (Blanc, Roi) 0 7 [(1, 7); (0, 6); (1, 6)];
  test_piece (Noir, Roi)  7 7 [(6, 7); (6, 6); (7, 6)];
  test_piece (Noir, Roi)  7 0 [(6, 1); (7, 1); (6, 0)]

let roi_dir () =
  test_piece_dir (Blanc, Roi) 0 0 [[(0, 1)]; [(1, 1)]; [(1, 0)]]

let test_roi = [
  "Normal", `Quick, roi_normal;
  "Côté",   `Quick, roi_cote;
  "Coin",   `Quick, roi_coin;
  "Dirigé", `Quick, roi_dir;
]


(*** Cavalier ***)
let cavalier_normal () =
  test_piece (Blanc, Cavalier) 2 5 [(1, 7); (3, 7); (0, 6); (4, 6); (0, 4); (4, 4); (1, 3); (3, 3)];
  test_piece (Noir, Cavalier)  3 3 [(2, 5); (4, 5); (1, 4); (5, 4); (1, 2); (5, 2); (2, 1); (4, 1)]

let cavalier_cote () =
  test_piece (Blanc, Cavalier) 1 0 [(0, 2); (2, 2); (3, 1)];
  test_piece (Noir, Cavalier)  6 4 [(5, 6); (7, 6); (4, 5); (4, 3); (5, 2); (7, 2)]

let cavalier_dir () =
  test_piece_dir (Blanc, Cavalier) 0 0 [[(1, 2)]; [(2, 1)]]

let test_cavalier = [
  "Normal", `Quick, cavalier_normal;
  "Côté",   `Quick, cavalier_cote;
  "Dirigé", `Quick, cavalier_dir;
]


(*** Fou ***)
let fou_dir () =
  test_piece_dir (Blanc, Fou) 2 5 [
    [(3, 6); (4, 7)]; [(1, 6); (0, 7)];
    [(3, 4); (4, 3); (5, 2); (6, 1); (7, 0)]; [(1, 4); (0, 3)]
  ];
  test_piece_dir (Blanc, Fou) 6 5 [
    [(7, 6)]; [(5, 6); (4, 7)]; [(7, 4)];
    [(5, 4); (4, 3); (3, 2); (2, 1); (1, 0)]
  ];
  test_piece_dir (Noir, Fou)  4 4 [
    [(5, 5); (6, 6); (7, 7)]; [(3, 5); (2, 6); (1, 7)];
    [(5, 3); (6, 2); (7, 1)]; [(3, 3); (2, 2); (1, 1); (0, 0)]
  ]

let fou_pas_dir () =
  test_piece (Noir, Fou) 0 0 [(1, 1); (2, 2); (3, 3); (4, 4); (5, 5); (6, 6); (7, 7)]

let test_fou = [
  "Dirigé",     `Quick, fou_dir;
  "Non dirigé", `Quick, fou_pas_dir;
]


(*** Tour ***)
let tour_dir () =
  test_piece_dir (Blanc, Tour) 2 5 [
    [(2, 6); (2, 7)]; [(2, 4); (2, 3); (2, 2); (2, 1); (2, 0)];
    [(3, 5); (4, 5); (5, 5); (6, 5); (7, 5)]; [(1, 5); (0, 5)]
  ];
  test_piece_dir (Blanc, Tour) 6 5 [
    [(6, 6); (6, 7)]; [(6, 4); (6, 3); (6, 2); (6, 1); (6, 0)];
    [(7, 5)]; [(5, 5); (4, 5); (3, 5); (2, 5); (1, 5); (0, 5)]
  ];
  test_piece_dir (Noir, Tour)  4 4 [
    [(4, 5); (4, 6); (4, 7)]; [(4, 3); (4, 2); (4, 1); (4, 0)];
    [(5, 4); (6, 4); (7, 4)]; [(3, 4); (2, 4); (1, 4); (0, 4)]
  ]

let tour_pas_dir () =
  test_piece (Noir, Tour) 0 0 [
    (0, 1); (0, 2); (0, 3); (0, 4); (0, 5); (0, 6); (0, 7);
    (1, 0); (2, 0); (3, 0); (4, 0); (5, 0); (6, 0); (7, 0)
  ]

let test_tour = [
  "Dirigé",     `Quick, tour_dir;
  "Non dirigé", `Quick, tour_pas_dir;
]


(*** Dame ***)
let dame_dir () =
  test_piece_dir (Noir, Dame) 2 2 [
    [(2, 3); (2, 4); (2, 5); (2, 6); (2, 7)]; [(2, 1); (2, 0)];
    [(3, 2); (4, 2); (5, 2); (6, 2); (7, 2)]; [(1, 2); (0, 2)];
    [(3, 3); (4, 4); (5, 5); (6, 6); (7, 7)]; [(1, 3); (0, 4)];
    [(3, 1); (4, 0)]; [(1, 1); (0, 0)]
  ]

let dame_pas_dir () =
  test_piece (Blanc, Dame) 6 5 [
    (6, 6); (6, 7); (6, 4); (6, 3); (6, 2); (6, 1); (6, 0);
    (7, 5); (5, 5); (4, 5); (3, 5); (2, 5); (1, 5); (0, 5);
    (7, 6); (5, 6); (4, 7); (7, 4); (5, 4); (4, 3); (3, 2);
    (2, 1); (1, 0)
  ]

let test_dame = [
  "Dirigé",     `Quick, dame_dir;
  "Non dirigé", `Quick, dame_pas_dir;
]

(*** Inverse ***)
let test_inverse () =
  Alcotest.check couleur "inverse Blanc = Noir" Noir (inverse Blanc);
  Alcotest.check couleur "inverse Noir = Blanc" Blanc (inverse Noir)


(*** Lancement des tests ***)
let () = Alcotest.run "Piece" [
  "Pion", test_pion;
  "Roi",  test_roi;
  "Cavalier", test_cavalier;
  "Fou", test_fou;
  "Tour", test_tour;
  "Dame", test_dame;
  "Inverse", ["Inverse", `Quick, test_inverse];
]