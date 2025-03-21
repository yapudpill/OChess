open Jeu
open EntreeSortie.Fen
open Regles.Basique

open TestUtil


(*** Fonctions de test ***)
let test_attaquee_dir fen (x, y) col attendu =
  let e = creer_partie_fen fen in
  let str =
    Printf.sprintf "%s : (%d, %d) attaquée par %s" fen x y
      (string_of_couleur col)
  in
  Alcotest.(check mouv_list_list) str attendu (attaquee_dir e col (x, y))

let test_coups_legaux fen (x, y) attendu =
  let p, _ = init_pos fen in
  let str = Printf.sprintf "%s : coups légaux depuis (%d, %d)" fen x y in
  Alcotest.(check mouv_list) str attendu (coups_legaux p (x, y))

let test_roque fen type_roque attendu =
  let p = creer_partie_fen fen in
  let str = Printf.sprintf "%s : roque de type %d" fen type_roque in
  Alcotest.(check bool) str attendu (peut_roquer p type_roque)

let test_of_algebrique fen algebrique attendu =
  let p = init_pos fen in
  let str =
    Printf.sprintf "%s : conversion de %s en coup" fen
      (string_of_algebrique algebrique)
  in
  Alcotest.(check (result coup erreur))
    str attendu
    (coup_of_algebrique p algebrique)

let test_mat fen attendu =
  Alcotest.(check bool) ("Mat " ^ fen) attendu (perdu (init_pos fen))

let test_pat fen attendu =
  Alcotest.(check bool) ("Pat " ^ fen) attendu (egalite (init_pos fen))


(*** Est attaquée ***)
let attaquee_simple () =
  test_attaquee_dir "5k2/8/2r5/B7/8/5Q2/8/3K4 w - -" (3, 4) Noir [[(4, 3); (5, 2)]];
  test_attaquee_dir "5k2/8/2r5/B7/8/5Q2/8/3K4 w - -" (1, 2) Noir [[(5, 2); (4, 2); (3, 2); (2, 2)]];
  test_attaquee_dir "5k2/8/2r5/B7/8/5Q2/8/3K4 w - -" (2, 1) Blanc [[(2, 5); (2, 4); (2, 3); (2, 2)]]

let attaquee_double () =
  test_attaquee_dir "5k2/8/2r5/B7/8/5Q2/8/3K4 w - -" (4, 1) Noir [[(3, 0)]; [(5, 2)]];
  test_attaquee_dir "5k2/8/2r5/B7/8/5Q2/8/3K4 w - -" (2, 2) Noir [[(5, 2); (4, 2); (3, 2)]; [(0, 4); (1, 3)]]

let attaquee_vide () =
  test_attaquee_dir "5k2/8/2r5/B7/8/5Q2/8/3K4 w - -" (4, 1) Blanc [];
  test_attaquee_dir "5k2/8/2r5/B7/8/5Q2/8/3K4 w - -" (4, 5) Noir []

let attaquee_bool () =
  let e = creer_partie_fen "5k2/8/2r5/B7/8/5Q2/8/3K4 w - -" in
  Alcotest.(check bool) "false" false (est_attaquee e Blanc (4, 1));
  Alcotest.(check bool) "true" true (est_attaquee e Blanc (2, 1))

let attaquee = [
  "Attaque simple",   `Quick, attaquee_simple;
  "Attaque double",   `Quick, attaquee_double;
  "Aucune attaque",   `Quick, attaquee_vide;
  "Prédicat booléen", `Quick, attaquee_bool;
]


(*** Cours légaux ***)
let legaux_blanc () =
  test_coups_legaux "r3k2r/pp2qppp/2n1pn2/bN2N3/3P4/P3B2P/1P2bPP1/R2Q1RK1 w kq -"
    (3, 0) [(3, 2); (3, 1); (4, 0); (1, 0); (2, 0); (4, 1); (0, 3); (1, 2); (2, 1)];
  test_coups_legaux "r3k2r/pp2qppp/2n1pn2/bN2N3/3P4/P3B2P/1P2bPP1/R2Q1RK1 w kq -"
    (4, 6) [];
  test_coups_legaux "r3k2r/pp2qppp/2n1pn2/bN2N3/3P4/P3B2P/1P2bPP1/R2Q1RK1 w kq -"
    (4, 4) [(3, 6); (5, 6); (2, 5); (6, 5); (2, 3); (6, 3); (3, 2); (5, 2)]

let legaux_noir () =
  test_coups_legaux "r3kb1r/pp3ppp/2n1pn2/2pq3b/3P4/2P1BN1P/PP2BPP1/RN1Q1RK1 b kq -"
    (2, 4) [(2, 3); (3, 3)];
  test_coups_legaux "r3kb1r/pp3ppp/2n1pn2/2pq3b/3P4/2P1BN1P/PP2BPP1/RN1Q1RK1 b kq -"
    (3, 4) [(3, 7); (3, 6); (3, 5); (3, 3); (6, 4); (5, 4); (4, 4); (5, 2); (4, 3); (0, 1); (1, 2); (2, 3)];
  test_coups_legaux "r3kb1r/pp3ppp/2n1pn2/2pq3b/3P4/2P1BN1P/PP2BPP1/RN1Q1RK1 b kq -"
    (7, 0) []

let legaux_bool () =
  let p,_ = init_pos "r3k2r/pp2qppp/2n1pn2/bN2N3/3P4/P3B2P/1P2bPP1/R2Q1RK1 w kq -" in
  Alcotest.(check bool) "true" true (est_legal p (3, 0) (4, 1));
  Alcotest.(check bool) "false" false (est_legal p (5, 0) (4, 1))

let legaux = [
  "Blancs", `Quick, legaux_blanc;
  "Noirs",  `Quick, legaux_noir;
  "Prédicat", `Quick, legaux_bool;
]


(*** Peut roquer ***)
let roque_blanc () =
  test_roque "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - KQkq -" 1 false;
  test_roque "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - KQkq -" (-1) false;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq -" 1 true;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq -" (-1) false;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w Qq -" 1 false;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w Qq -" (-1) false;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/2b1p1B1/3PP3/1BN2N2/PPP2PPP/R2QK2R w KQkq -" 1 false;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/2b1p1B1/3PP3/1BN2N2/PPP2PPP/R2QK2R w KQkq -" (-1) false;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/3Np1B1/1b2P3/1B1P1N2/PPP2PPP/R2QK2R w KQkq -" 1 false;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/3Np1B1/1b2P3/1B1P1N2/PPP2PPP/R2QK2R w KQkq -" (-1) false;
  test_roque "r4rk1/pppbqppp/2n1pn2/3p4/1bPP1B2/2N1PN2/PPQ2PPP/R3KB1R w KQq -" 1 false;
  test_roque "r4rk1/pppbqppp/2n1pn2/3p4/1bPP1B2/2N1PN2/PPQ2PPP/R3KB1R w KQq -" (-1) true

let roque_noir () =
  test_roque "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq -" 1 false;
  test_roque "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq -" 1 false;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq -" 1 true;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq -" (-1) false;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b Qq -" 1 false;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b Qq -" (-1) false;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/2b1p1B1/3PP3/1BN2N2/PPP2PPP/R2QK2R b KQkq -" 1 true;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/2b1p1B1/3PP3/1BN2N2/PPP2PPP/R2QK2R b KQkq -" (-1) false;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/3Np1B1/1b2P3/1B1P1N2/PPP2PPP/R2QK2R b KQkq -" 1 true;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/3Np1B1/1b2P3/1B1P1N2/PPP2PPP/R2QK2R b KQkq -" (-1) false;
  test_roque "r4rk1/pppbqppp/2n1pn2/3p4/1bPP1B2/2N1PN2/PPQ2PPP/R3KB1R b KQ -" 1 false;
  test_roque "r4rk1/pppbqppp/2n1pn2/3p4/1bPP1B2/2N1PN2/PPQ2PPP/R3KB1R b KQ -" (-1) false

let roque = [
  "Blanc", `Quick, roque_blanc;
  "Noir", `Quick, roque_noir;
]


(*** Coup of algébrique ***)
let coups_pion () =
  test_of_algebrique "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -"
    (Arrivee (Pion, (4, 3)))
    (Ok (Mouvement ((4, 1), (4, 3))));
  test_of_algebrique
    "r2qk2r/pp1b1ppp/1Pnbpn2/3p2B1/Pp1PP3/Q1N2N2/2P1BPPP/R3K2R b - -"
    (Arrivee (Pion, (0, 2)))
    (Ok (Mouvement ((1, 3), (0, 2))));
  test_of_algebrique "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq -"
    (Arrivee (Pion, (4, 4)))
    (Ok (Mouvement ((4, 6), (4, 4))));
  test_of_algebrique "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -"
    (Arrivee (Pion, (4, 2)))
    (Ok (Mouvement ((4, 1), (4, 2))));
  test_of_algebrique "8/3N1pkp/4p1p1/3pb3/8/1P3P2/4Q1PP/R4K2 b - -"
    (Arrivee (Pion, (3, 3)))
    (Ok (Mouvement ((3, 4), (3, 3))));
  test_of_algebrique "8/3N1pkp/4p3/3pb3/5pP1/1P3P2/4Q2P/R4K2 b - g3"
    (Arrivee (Pion, (6, 2)))
    (Ok (Mouvement ((5, 3), (6, 2))));
  test_of_algebrique "7k/8/8/1pP5/8/8/8/7K w - b6"
    (Arrivee (Pion, (1, 5)))
    (Ok (Mouvement ((2, 4), (1, 5))));
  test_of_algebrique
    "r1bqkbnr/ppp2ppp/1Pn1p3/3p4/3P4/5N2/P1P1PPPP/RNBQKB1R b K -"
    (Arrivee (Pion, (1, 5)))
    (Error (Ambigu [ 0, 6; 2, 6 ]));
  test_of_algebrique "rnbqkbn1/pppppppp/6r1/8/2R1P3/8/PPPP1PPR/1NBQKBN1 w q -"
    (Arrivee (Pion, (0, 0)))
    (Error Invalide);
  test_of_algebrique "rnbqkbn1/pppppppp/6r1/8/2R1P3/8/PPPP1PPR/1NBQKBN1 b q -"
    (Arrivee (Pion, (7, 7)))
    (Error Invalide)

let coups_autre () =
  test_of_algebrique "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -"
    (Arrivee (Cavalier, (5, 2)))
    (Ok (Mouvement ((6, 0), (5, 2))));
  test_of_algebrique
    "r1bqkbnr/ppp2ppp/1Pn1p3/3p4/3P4/5N2/P1P1PPPP/RNBQKB1R w K -"
    (Arrivee (Fou, (6, 4)))
    (Ok (Mouvement ((2, 0), (6, 4))));
  test_of_algebrique
    "r2qk2r/pppb1ppp/1Pnbpn2/3p2B1/P2PP3/Q1N2N2/2P1BPPP/R3K2R w - -"
    (Arrivee (Dame, (3, 5)))
    (Ok (Mouvement ((0, 2), (3, 5))));
  test_of_algebrique
    "r2qk2r/pppb1ppp/1Pnbpn2/3p2B1/P2PP3/Q1N2N2/2P1BPPP/R3K2R b - -"
    (Arrivee (Tour, (2, 7)))
    (Ok (Mouvement ((0, 7), (2, 7))));
  test_of_algebrique "2bqkbnr/p2ppppp/R7/1Pp5/8/8/2PPPPP1/1NBQKBNR w Kk c6"
    (Arrivee (Tour, (2, 5)))
    (Ok (Mouvement ((0, 5), (2, 5))));
  test_of_algebrique
    "r2qk2r/pppb1ppp/1Pnbpn2/3p2B1/P2PP3/Q1N2N2/2P1BPPP/R3K2R b - -"
    (Arrivee (Roi, (4, 6)))
    (Ok (Mouvement ((4, 7), (4, 6))));
  test_of_algebrique "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq -"
    (Arrivee (Cavalier, (5, 2)))
    (Error Invalide);
  test_of_algebrique
    "r1bqkbnr/ppp2ppp/2n1p3/3p4/3P4/5N2/PPP1PPPP/RNBQKB1R w KQk -"
    (Arrivee (Cavalier, (3, 1)))
    (Error (Ambigu [ 5, 2; 1, 0 ]))

let coups_roque () =
  test_of_algebrique "4k2r/8/8/8/8/8/8/R3K3 w Qk -" Grand_Roque (Ok Grand_Roque);
  test_of_algebrique "4k2r/8/8/8/8/8/8/R3K3 w Qk -" Petit_Roque (Error Invalide);
  test_of_algebrique "4k2r/8/8/8/8/8/8/R3K3 b Qk -" Grand_Roque (Error Invalide);
  test_of_algebrique "4k2r/8/8/8/8/8/8/R3K3 b Qk -" Petit_Roque (Ok Petit_Roque)

let coups = [
  "Pion",   `Quick, coups_pion;
  "Autres", `Quick, coups_autre;
  "Roque",  `Quick, coups_roque;
]

(*** Fin de partie ***)
let mat_blancs () =
  test_mat "rnb1k1nr/pppp1ppp/8/1b2p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq -" false;
  test_mat "rnb1k1nr/pppp1ppp/8/2b1p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq -" true;
  test_mat "1kbnr/pppp1ppp/2n5/4p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq -" false;
  test_mat "1r6/2r5/8/7k/8/8/8/1K6 w - -" false;
  test_mat "r7/1r6/8/7k/8/8/K3B1q1/8 w - -" true;
  test_mat "r7/1r6/8/7k/8/8/K3B3/6q1 w - -" false;
  test_mat "8/4k3/8/2r3bb/8/8/1P6/1RK5 w - -" true;
  test_mat "8/4k2N/8/2r3bb/8/8/1P6/1RK5 w - -" true;
  test_mat "8/4kb1N/8/2r3b1/8/8/1P6/1RK5 w - -" false;
  test_mat "1k6/8/8/8/8/8/r1r5/1K6 w - -" false

let mat_noirs () =
  test_mat "2k4R/8/2K5/8/8/8/8/8 b - -" true;
  test_mat "2k5/4N3/1K1Q4/8/8/8/8/8 b - -" true;
  test_mat "2k5/7R/2K5/8/8/8/8/8 b - -" false;
  test_mat "2k5/8/1K1Q4/8/8/8/8/8 b - -" false

let pat () =
  test_pat "1k6/8/8/8/8/8/r1r5/1K6 b - -" false;
  test_pat "8/8/p2k1n2/Pp6/1P1K4/6r1/8/8 w - -" true;
  test_pat "1k6/8/8/8/8/8/r1r5/1K6 w - -" true;
  test_pat "2k4R/8/2K5/8/8/8/8/8 b - -" false;
  test_pat "8/8/p2k2n1/Pp6/1P1K4/6r1/8/8 w - -" false

let fin = [
  "Mat blancs", `Quick, mat_blancs;
  "Mat noirs", `Quick, mat_noirs;
  "Pat", `Quick, pat;
]


(*** Jouer **)
let petit_roque () =
  let open Echiquier in
  let p =
    init_pos
      "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq -"
  in
  let p, _ = jouer p Petit_Roque in
  Alcotest.check case "Roi" (Some (Blanc, Roi)) p.echiquier.${6, 0};
  Alcotest.check case "Tour" (Some (Blanc, Tour)) p.echiquier.${5, 0};
  Alcotest.(check (pair bool bool)) "Roque" (false, false) (Partie.get_roque p Blanc)

let grand_roque () =
  let open Echiquier in
  let p =
    init_pos "r4rk1/pppbqppp/2n1pn2/3p4/1bPP1B2/2N1PN2/PPQ2PPP/R3KB1R w KQq -"
  in
  let p, _ = jouer p Grand_Roque in
  Alcotest.check case "Roi" (Some (Blanc, Roi)) p.echiquier.${2, 0};
  Alcotest.check case "Tour" (Some (Blanc, Tour)) p.echiquier.${3, 0};
  Alcotest.(check (pair bool bool)) "Roque" (false, false) (Partie.get_roque p Blanc)

let roque_invalide () =
  let p =
    init_pos "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w - -"
  in
  Alcotest.check_raises "Invalide" (Failure "roque")
    (fun () -> ignore @@ jouer p Petit_Roque)

let test_jouer_blanc () =
  let open Echiquier in
  let p = init_pos "8/1P4k1/8/8/4r3/4R3/8/4K3 w - -" in
  let p1, _ = jouer p (Mouvement ((4, 2), (4, 3))) in
  let p2, _ = jouer p (Mouvement ((1, 6), (1, 7))) in
  Alcotest.check case "Coup valide" (Some (Blanc, Tour)) p1.echiquier.${4, 3};
  Alcotest.check case "Promotion" (Some (Blanc, Dame)) p2.echiquier.${1, 7};
  Alcotest.check_raises "Invalide" (Failure "jouer")
    (fun () -> ignore @@ jouer p (Mouvement ((4, 2), (3, 2))))

let test_jouer_noir () =
  let open Echiquier in
  let p = init_pos "8/6k1/8/8/4r3/4R3/1p6/4K3 b - -" in
  let p1, _ = jouer p (Mouvement ((4, 3), (5, 3))) in
  let p2, _ = jouer p (Mouvement ((1, 1), (1, 0))) in
  Alcotest.check case "Coup valide" (Some (Noir, Tour)) p1.echiquier.${5, 3};
  Alcotest.check case "Promotion" (Some (Noir, Dame)) p2.echiquier.${1, 0}

let jouer = [
  "Grand roque",    `Quick, grand_roque;
  "Petit roque",    `Quick, petit_roque;
  "Roque invalide", `Quick, roque_invalide;
  "Coup blancs",    `Quick, test_jouer_blanc;
  "Coup noirs",     `Quick, test_jouer_noir;
]


let () = Alcotest.run "Regle Basique" [
  "Est attaquée", attaquee;
  "Coups légaux", legaux;
  "Peut Roquer", roque;
  "Algébrique vers coup", coups;
  "Fin de partie", fin;
  "Jouer", jouer;
]