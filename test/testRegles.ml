open OChess
open Fen

let test_mat fen attendu  =
  Alcotest.(check bool) ("Mat " ^ fen) attendu (ReglesBasiques.mat @@ creer_partie_fen fen)

let test_pat fen attendu  =
  Alcotest.(check bool) ("Pat " ^ fen) attendu (ReglesBasiques.pat @@ creer_partie_fen fen)

let test_roque fen type_roque attendu  =
  Alcotest.(check bool) ("roque " ^ fen) attendu (ReglesBasiques.peut_roquer (creer_partie_fen fen) type_roque)

let test_case_depart fen p arr attendu =
  let partie = creer_partie_fen fen in
  Alcotest.check TestUtil.mouv_list ("Départ " ^ fen) attendu (ReglesBasiques.case_depart partie p arr)

let test_terminee fen attendu =
  Alcotest.(check bool) ("Terminée " ^ fen) attendu (ReglesBasiques.terminee @@ creer_partie_fen fen)



let mat_blancs () =
  test_mat "rnb1k1nr/pppp1ppp/8/1b2p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq " false;
  test_mat "rnb1k1nr/pppp1ppp/8/2b1p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq" true;
  test_mat "1kbnr/pppp1ppp/2n5/4p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq" false;
  test_mat "1r6/2r5/8/8/8/8/8/1K6 w -" false;
  test_mat "r7/1r6/8/8/8/8/K3B1q1/8 w -" true;
  test_mat "r7/1r6/8/8/8/8/K3B3/6q1 w -" false;
  test_mat "8/4k3/8/2r3bb/8/8/1P6/1RK5 w -" true;
  test_mat "8/4k2N/8/2r3bb/8/8/1P6/1RK5 w -" true;
  test_mat "8/4kb1N/8/2r3b1/8/8/1P6/1RK5 w - " false;
  test_mat "1k6/8/8/8/8/8/r1r5/1K6 w -" false


let mat_noirs () =
  test_mat "2k4R/8/2K5/8/8/8/8/8 b -" true;
  test_mat "2k5/4N3/1K1Q4/8/8/8/8/8 b -" true;
  test_mat "2k5/7R/2K5/8/8/8/8/8 b -" false;
  test_mat "2k5/8/1K1Q4/8/8/8/8/8 b -" false

let pat () =

  test_pat "1k6/8/8/8/8/8/r1r5/1K6 b -" false;
  test_pat "8/8/p2k1n2/Pp6/1P1K4/6r1/8/8 w -" true;
  test_pat "1k6/8/8/8/8/8/r1r5/1K6 w -" true;
  test_pat "2k4R/8/2K5/8/8/8/8/8 b -" false;
  test_pat "8/8/p2k2n1/Pp6/1P1K4/6r1/8/8 w -" false

let roque_blanc () =
  test_roque "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - KQkq" 1 false;
  test_roque "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - KQkq" (-1) false;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq" 1 true;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq" (-1) false;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w Qq" 1 false;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w Qq" (-1) false;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/2b1p1B1/3PP3/1BN2N2/PPP2PPP/R2QK2R w KQkq" 1 false;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/2b1p1B1/3PP3/1BN2N2/PPP2PPP/R2QK2R w KQkq" (-1) false;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/3Np1B1/1b2P3/1B1P1N2/PPP2PPP/R2QK2R w KQkq" 1 false;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/3Np1B1/1b2P3/1B1P1N2/PPP2PPP/R2QK2R w KQkq" (-1) false;
  test_roque "r4rk1/pppbqppp/2n1pn2/3p4/1bPP1B2/2N1PN2/PPQ2PPP/R3KB1R w KQq" 1 false;
  test_roque "r4rk1/pppbqppp/2n1pn2/3p4/1bPP1B2/2N1PN2/PPQ2PPP/R3KB1R w KQq" (-1) true


let roque_noir () =
  test_roque "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b - KQkq" 1 false;
  test_roque "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b - KQkq" 1 false;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq" 1 true;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq" (-1) false;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b Qq" 1 false;
  test_roque "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b Qq" (-1) false;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/2b1p1B1/3PP3/1BN2N2/PPP2PPP/R2QK2R b KQkq" 1 true;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/2b1p1B1/3PP3/1BN2N2/PPP2PPP/R2QK2R b KQkq" (-1) false;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/3Np1B1/1b2P3/1B1P1N2/PPP2PPP/R2QK2R b KQkq" 1 true;
  test_roque "r2qk2r/p1pp1ppp/bpn2n2/3Np1B1/1b2P3/1B1P1N2/PPP2PPP/R2QK2R b KQkq" (-1) false;
  test_roque "r4rk1/pppbqppp/2n1pn2/3p4/1bPP1B2/2N1PN2/PPQ2PPP/R3KB1R b KQ" 1 false;
  test_roque "r4rk1/pppbqppp/2n1pn2/3p4/1bPP1B2/2N1PN2/PPQ2PPP/R3KB1R b KQ" (-1) false


let case_depart_pion () =
  test_case_depart "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq" Pion (4,3) [(4,1)];
  test_case_depart "r1bqkbnr/ppp2ppp/1Pn1p3/3p4/3P4/5N2/P1P1PPPP/RNBQKB1R b K" Pion (1,5) [(0,6);(2,6)];
  test_case_depart "r2qk2r/pp1b1ppp/1Pnbpn2/3p2B1/Pp1PP3/Q1N2N2/2P1BPPP/R3K2R b -" Pion (0,2) [(1,3)];
  test_case_depart "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq" Pion (4,4) [(4,6)];
  test_case_depart "rnbqkbn1/pppppppp/6r1/8/2R1P3/8/PPPP1PPR/1NBQKBN1 b q" Pion (7,7) [];
  test_case_depart "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq" Pion (4,2) [(4,1)];
  test_case_depart "8/3N1pkp/4p1p1/3pb3/8/1P3P2/4Q1PP/R4K2 b - " Pion (3,3) [(3,4)];
  test_case_depart "rnbqkbn1/pppppppp/6r1/8/2R1P3/8/PPPP1PPR/1NBQKBN1 w q" Pion (0,0) []

let case_depart_autre () =
  test_case_depart "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq" Cavalier (5,2) [(6,0)];
  test_case_depart "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq" Cavalier (5,2) [];
  test_case_depart "r1bqkbnr/ppp2ppp/2n1p3/3p4/3P4/5N2/PPP1PPPP/RNBQKB1R w KQk" Cavalier (3,1) [(5,2);(1,0)];
  test_case_depart "r1bqkbnr/ppp2ppp/1Pn1p3/3p4/3P4/5N2/P1P1PPPP/RNBQKB1R w K" Fou (6,4) [(2,0)];
  test_case_depart "r2qk2r/pppb1ppp/1Pnbpn2/3p2B1/P2PP3/Q1N2N2/2P1BPPP/R3K2R w -" Dame (3,5) [(0,2)];
  test_case_depart "r2qk2r/pppb1ppp/1Pnbpn2/3p2B1/P2PP3/Q1N2N2/2P1BPPP/R3K2R b -" Tour ((2,7)) [(0,7)];
  test_case_depart "r2qk2r/pppb1ppp/1Pnbpn2/3p2B1/P2PP3/Q1N2N2/2P1BPPP/R3K2R b -" Roi (4,6) [(4,7)]


let terminee () =
  test_terminee "2k4R/8/2K5/8/8/8/8/8 b -" true;
  test_terminee "8/8/p2k1n2/Pp6/1P1K4/6r1/8/8 w -" true;
  test_terminee "8/3N1pkp/4p1p1/3pb3/8/1P3P2/4Q1PP/R4K2 b -" false



let mat = [
  "Mat Blancs", `Quick, mat_blancs;
  "Mat Noirs", `Quick, mat_noirs
]

let pat = [
  "Pat", `Quick, pat
]

let roque = [
  "Roque blanc", `Quick, roque_blanc;
  "Roque noir", `Quick, roque_noir;
]

let case_depart = [
  "Case(s) départ pion", `Quick, case_depart_pion;
  "Case(s) départ autre", `Quick, case_depart_autre
]

let terminee = [
  "Partie terminée", `Quick, terminee
]

let () = Alcotest.run "Mat et Pat" [
  "Pat", pat;
  "Roque", roque;
  "Mat", mat;
  "Case(s) départ", case_depart;
  "Partie terminée", terminee
]