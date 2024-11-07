open Jeu.Echiquier
open EntreeSortie

open TestUtil

(* Accesseurs *)
let test_set_get () =
  let p =
    Fen.creer_partie_fen
      "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R w - -"
  in
  let e = p.echiquier in
  Alcotest.check case "Get vide b3" None e.${1, 2};
  Alcotest.check case "Get blanc f3" (Some (Blanc, Cavalier)) e.${5, 2};
  Alcotest.check case "Get noir h7" (Some (Noir, Pion)) e.${7, 6};

  e.${2, 3} <- None;
  Alcotest.check case "Set vide c4" None e.${2, 3};
  e.${3, 1} <- Some (Blanc, Pion);
  Alcotest.check case "Set blanc d2" (Some (Blanc, Pion)) e.${3, 1}

let test_accesseurs = [
  "(.${}) et (.${}<-)", `Quick, test_set_get
]


(* Prédicats *)
let test_est_adversaire () =
  let p =
    Fen.creer_partie_fen
      "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R w - -"
  in
  let e = p.echiquier in
  Alcotest.(check bool) "Vide" false (est_adversaire Blanc e.${6, 3});
  Alcotest.(check bool) "Allié" false (est_adversaire Blanc e.${7, 0});
  Alcotest.(check bool) "Adversaire" true (est_adversaire Blanc e.${3, 7})

let test_est_vide () =
  let p =
    Fen.creer_partie_fen
      "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R w - -"
  in
  let e = p.echiquier in
  Alcotest.(check bool) "Vide" true (est_vide e.${6, 3});
  Alcotest.(check bool) "Pas vide" false (est_vide e.${3, 7})

let test_est_vide_ou_adversaire () =
  let p =
    Fen.creer_partie_fen
      "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R w - -"
  in
  let e = p.echiquier in
  Alcotest.(check bool) "Vide" true (est_vide_ou_adversaire Blanc e.${6, 3});
  Alcotest.(check bool) "Allié" false (est_vide_ou_adversaire Blanc e.${7, 0});
  Alcotest.(check bool) "Adversaire" true (est_vide_ou_adversaire Blanc e.${3, 7})

let predicats = [
  "est_adversaire", `Quick, test_est_adversaire;
  "est_vide", `Quick, test_est_vide;
  "test_vide_ou_adversaire", `Quick, test_est_vide_ou_adversaire;
]


let () = Alcotest.run "Échiquier" [
  "Accesseurs", test_accesseurs;
  "Prédicats", predicats
]