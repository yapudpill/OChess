open OChess
open Echiquier

open TestUtil

(* Accesseurs *)
let test_set_get () =
  let e = Fen.from_fen "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R" in
  Alcotest.check case "Get vide b3" Vide e.${1, 2};
  Alcotest.check case "Get blanc f3" (Piece (Blanc, Cavalier)) e.${5, 2};
  Alcotest.check case "Get noir h7" (Piece (Noir, Pion)) e.${7, 6};

  e.${2, 3} <- Vide;
  Alcotest.check case "Set vide c4" Vide e.${2, 3};
  e.${3, 1} <- Piece (Blanc, Pion);
  Alcotest.check case "Set blanc d2" (Piece (Blanc, Pion)) e.${3, 1}

let test_accesseurs = [
  "(.${}) et (.${}<-)", `Quick, test_set_get
]


(* Prédicats *)
let test_est_adversaire () =
  let e = Fen.from_fen "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R" in
  Alcotest.(check bool) "Vide" false (est_adversaire Blanc e.${6, 3});
  Alcotest.(check bool) "Allié" false (est_adversaire Blanc e.${7, 0});
  Alcotest.(check bool) "Adversaire" true (est_adversaire Blanc e.${3, 7})

let test_est_vide () =
  let e = Fen.from_fen "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R" in
  Alcotest.(check bool) "Vide" true (est_vide e.${6, 3});
  Alcotest.(check bool) "Pas vide" false (est_vide e.${3, 7})

let test_est_vide_ou_adversaire () =
  let e = Fen.from_fen "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R" in
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