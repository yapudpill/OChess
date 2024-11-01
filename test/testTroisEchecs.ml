open Regles.TroisEchecs

open TestUtil


let test_perdu (partie,infos) attendu =
  Alcotest.(check bool) "" attendu (perdu (partie,infos)  )

let test_egalite fen attendu  =
  Alcotest.(check bool) ("Egalité " ^ fen) attendu (egalite (init_pos fen))

let test_string (partie,infos) attendu =
  Alcotest.(check string) "" attendu (Option.value (string_of_infos (partie, infos)) ~default:"")


(*** to_string ***)

let to_string () =
  test_string (init_partie ()) "echecs blanc : 0, echecs noir : 0";
  let p = init_partie () in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((4, 1), (4, 3))) in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((3, 6), (3, 4))) in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((5, 0), (1, 4))) in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((2, 6), (2, 5))) in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((1,4), (2, 5))) in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((2, 7), (3, 6))) in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((2, 5), (3, 6))) in
  test_string p "echecs blanc : 0, echecs noir : 3"



let string_info = [
  "string info",    `Quick, to_string;
]

(*** Jouer **)

let test_jouer_blanc () =
  let open Jeu.Echiquier in
  let p = init_pos "7k/1P6/8/8/4r3/4R3/8/4K3 w - -" in
  let p1,_ = jouer p (Mouvement ((4, 2), (4, 3))) in
  let p2,_ = jouer p (Mouvement ((1, 6), (1, 7))) in
  Alcotest.check case "Coup valide" (Some (Blanc, Tour)) p1.echiquier.${4, 3};
  Alcotest.check case "Promotion"   (Some (Blanc, Dame)) p2.echiquier.${1, 7};
  Alcotest.check_raises "Invalide" (Failure "jouer")
    (fun () -> ignore @@ jouer p (Mouvement ((4, 2), (3, 2))))

let test_jouer_noir () =
  let open Jeu.Echiquier in
  let p = init_pos "8/6k1/8/8/4r3/4R3/1p6/4K3 b - -" in
  let p1,_ = jouer p (Mouvement ((4, 3), (4, 2))) in
  let p2,_ = jouer p (Mouvement ((1, 1), (1, 0))) in
  Alcotest.check case "Coup valide" (Some (Noir, Tour)) p1.echiquier.${4, 2};
  Alcotest.check case "Promotion"   (Some (Noir, Dame)) p2.echiquier.${1, 0}

let jouer = [
  "Coup blancs",    `Quick, test_jouer_blanc;
  "Coup noirs",     `Quick, test_jouer_noir;
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

let troisEchecs () =
  let p = init_partie () in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((4, 1), (4, 3))) in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((3, 6), (3, 4))) in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((5, 0), (1, 4))) in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((2, 6), (2, 5))) in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((1,4), (2, 5))) in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((2, 7), (3, 6))) in
  let p = Regles.TroisEchecs.jouer p (Mouvement ((2, 5), (3, 6))) in
  test_perdu p true


let fin = [
  "Gain blanc", `Quick, gain_blanc;
  "Gain noir", `Quick, gain_noirs;
  "egalite", `Quick, egalite;
  "Trois echecs", `Quick, troisEchecs;
]

let () = Alcotest.run "Regles Trois Echecs" [
  "String info", string_info;
  "Jouer", jouer;
  "Fin de partie", fin;
]