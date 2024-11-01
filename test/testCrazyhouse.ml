open Regles.Crazyhouse
open TestUtil


let test_perdu (partie,infos) attendu =
  Alcotest.(check bool) "" attendu (perdu (partie,infos))

let test_egalite fen attendu  =
  Alcotest.(check bool) ("Egalité " ^ fen) attendu (egalite (init_pos fen))

let test_string (partie,infos) attendu =
  Alcotest.(check (option string)) "" attendu (string_of_infos (partie, infos))


(*** to_string ***)

let to_string_noir_1 () =
  let p = init_partie () in
  test_string p (Some "");
  let p = jouer p (Mouvement ((4, 1), (4, 3))) in
  let p = jouer p (Mouvement ((3, 6), (3, 4))) in
  let p = jouer p (Mouvement ((4, 3), (3, 4))) in
  test_string p (Some "")

let to_string_noir_2 () =
  let p = init_partie () in
  test_string p (Some "");
  let p = jouer p (Mouvement ((4, 1), (4, 3))) in
  let p = jouer p (Mouvement ((3, 6), (3, 4))) in
  let p = jouer p (Mouvement ((4, 3), (3, 4))) in
  let p = jouer p (Mouvement ((3, 7), (3, 4))) in
  let p = jouer p (Mouvement ((1, 0), (2, 2))) in
  test_string p (Some "P")



let to_string_blanc () =
  let p = init_partie () in
  test_string p (Some "");
  let p = jouer p (Mouvement ((4, 1), (4, 3))) in
  let p = jouer p (Mouvement ((3, 6), (3, 4))) in
  let p = jouer p (Mouvement ((4, 3), (3, 4))) in
  let p = jouer p (Mouvement ((3, 7), (3, 4))) in
  test_string p (Some "P")


let string_info = [
  "string info blanc", `Quick, to_string_blanc;
  "string info noir", `Quick, to_string_noir_1;
  "string info noir", `Quick, to_string_noir_2;
]

(*** Roque ***)


let test_petit_roque () =
  let open Jeu.Echiquier in
  let p = init_partie () in
  let p = jouer p (Mouvement ((4, 1), (4, 3))) in
  let p = jouer p (Mouvement ((3, 6), (3, 4))) in
  let p = jouer p (Mouvement ((6, 0), (5, 2))) in
  let p = jouer p (Mouvement ((0, 6), (0, 5))) in
  let p = jouer p (Mouvement ((5, 0), (4, 1))) in
  let p = jouer p (Mouvement ((0, 5), (0, 4))) in
  let p,_ = jouer p Petit_Roque in
  Alcotest.check case "Coup valide" (Some (Blanc, Roi))  p.echiquier.${6, 0};
  Alcotest.check case "Coup valide" (Some (Blanc, Tour)) p.echiquier.${5, 0}


let test_grand_roque () =
  let open Jeu.Echiquier in
  let p = init_partie () in
  let p = jouer p (Mouvement ((3, 1), (3, 3))) in
  let p = jouer p (Mouvement ((3, 6), (3, 4))) in
  let p = jouer p (Mouvement ((1, 0), (2, 2))) in
  let p = jouer p (Mouvement ((0, 6), (0, 5))) in
  let p = jouer p (Mouvement ((2, 0), (5, 3))) in
  let p = jouer p (Mouvement ((0, 5), (0, 4))) in
  let p = jouer p (Mouvement ((3, 0), (3, 1))) in
  let p = jouer p (Mouvement ((0, 4), (0, 3))) in
  let p,_ = jouer p (Grand_Roque) in
  Alcotest.check case "Coup valide" (Some (Blanc, Roi))  p.echiquier.${2, 0};
  Alcotest.check case "Coup valide" (Some (Blanc, Tour)) p.echiquier.${3, 0}


(*** Jouer **)



let test_placement () =
  let open Jeu.Echiquier in
  let p = init_partie () in
  let p1,infos = jouer p (Mouvement ((4, 1), (4, 3))) in
  let p2,infos = jouer (p1,infos) (Mouvement ((3, 6), (3, 4))) in
  Alcotest.check case "Coup valide" (Some (Blanc, Pion)) p1.echiquier.${4, 3};
  Alcotest.check case "Coup Valide"   (Some (Noir, Pion)) p2.echiquier.${3, 4};
  let p1,infos = jouer (p2,infos) (Mouvement ((4, 3), (3, 4))) in
  Alcotest.check case "Coup valide" (Some (Blanc, Pion)) p1.echiquier.${3, 4};
  let p2,infos = Regles.Crazyhouse.jouer (p1,infos) (Mouvement ((3, 7), (3, 4))) in
  Alcotest.check case "Coup valide"   (Some (Noir, Dame)) p2.echiquier.${3, 4};
  let p1,infos = jouer (p2,infos) (Placement (Pion, (4, 2))) in
  Alcotest.check case "Placement valide" (Some (Blanc, Pion)) p1.echiquier.${4, 2};
  let p2,_ = jouer (p1,infos) (Placement (Pion, (4, 4))) in
  Alcotest.check case "Placement valide" (Some (Blanc, Pion)) p2.echiquier.${4, 2}


let jouer = [
  "Placement", `Quick,test_placement;
  "Petit roque", `Quick,test_petit_roque;
  "Grand roque", `Quick,test_grand_roque;

]



(* Fin de partie*)

let gain_blanc () =
  test_perdu (init_pos "rnb1k1nr/pppp1ppp/8/1b2p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq -") false;
  test_perdu (init_pos "rnb1k1nr/pppp1ppp/8/2b1p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq -") true;
  test_perdu (init_pos "1kbnr/pppp1ppp/2n5/4p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq -") false;
  test_perdu (init_pos "1r6/2r5/8/7k/8/8/8/1K6 w - -") false;
  test_perdu (init_pos "r7/1r6/8/7k/8/8/K3B1q1/8 w - -") true;
  test_perdu (init_pos "r7/1r6/8/7k/8/8/K3B3/6q1 w - -") false;
  test_perdu (init_pos "8/4k3/8/2r3bb/8/8/1P6/1RK5 w - -") true;
  test_perdu (init_pos "8/4k2N/8/2r3bb/8/8/1P6/1RK5 w - -") true;
  test_perdu (init_pos "8/4kb1N/8/2r3b1/8/8/1P6/1RK5 w - -") false;
  test_perdu (init_pos "1k6/8/8/8/8/8/r1r5/1K6 w - -") false;
  test_perdu (init_pos "rnbqkb1r/ppp1pppp/5n2/3p4/4P3/3K4/PPPP1PPP/RNBQ1BNR w kq -") false

let gain_noirs () =
  test_perdu (init_pos "2k4R/8/2K5/8/8/8/8/8 b - -") true;
  test_perdu (init_pos "2k5/4N3/1K1Q4/8/8/8/8/8 b - -") true;
  test_perdu (init_pos "2k5/7R/2K5/8/8/8/8/8 b - -") false;
  test_perdu (init_pos "2k5/8/1K1Q4/8/8/8/8/8 b - -") false

let egalite () =
  test_egalite "1k6/8/8/8/8/8/r1r5/1K6 b - -" false;
  test_egalite "8/8/p2k1n2/Pp6/1P1K4/6r1/8/8 w - -" true;
  test_egalite "1k6/8/8/8/8/8/r1r5/1K6 w - -" true;
  test_egalite "2k4R/8/2K5/8/8/8/8/8 b - -" false;
  test_egalite "8/8/p2k2n1/Pp6/1P1K4/6r1/8/8 w - -" false


let fin = [
  "Gain blanc", `Quick, gain_blanc;
  "Gain noir", `Quick, gain_noirs;
  "egalite", `Quick, egalite;
]

let () = Alcotest.run "Regles Crazyhouse" [
  "String info", string_info;
  "Jouer", jouer;
  "Fin de partie", fin;
]