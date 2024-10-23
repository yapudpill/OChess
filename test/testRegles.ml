open OChess
open Fen

(* let test_mat fen provenance attendu  =
  let p = creer_partie_fen fen in
  Alcotest.(check bool) ("Mat " ^ fen) attendu (ReglesBasiques.mat p provenance) *)

let test_pat fen attendu  =
  Alcotest.(check bool) ("Pat " ^ fen) attendu (ReglesBasiques.pat @@ creer_partie_fen fen)

let test_roque fen type_roque attendu  =
  Alcotest.(check bool) ("roque " ^ fen) attendu (ReglesBasiques.peut_roquer (creer_partie_fen fen) type_roque)

(* let mat_blancs () =
  test_mat "rnb1k1nr/pppp1ppp/8/1b2p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq " (5,1) false;
  test_mat "rnb1k1nr/pppp1ppp/8/2b1p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq" (5,1) true;
  test_mat "1kbnr/pppp1ppp/2n5/4p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq" (5,1) false;
  test_mat "1r6/2r5/8/8/8/8/8/1K6 w -" (1,7) false;
  test_mat "1k6/8/8/8/8/8/r1r5/1K6 w -" (1,3) false


let mat_noirs () =
  test_mat "2k4R/8/2K5/8/8/8/8/8 b -" (7,7) true;
  test_mat "2k5/4N3/1K1Q4/8/8/8/8/8 b -" (4,6) true;
  test_mat "2k5/7R/2K5/8/8/8/8/8 b -" (5,1) false;
  test_mat "2k5/8/1K1Q4/8/8/8/8/8 b -" (1,7) false *)

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


(*
let mat = [
  "Mat Blancs", `Quick, mat_blancs;
  "Mat Noirs", `Quick, mat_noirs
] *)

let pat = [
  "Pat", `Quick, pat
]

let roque = [
  "Roque blanc", `Quick, roque_blanc;
  "Roque noir", `Quick, roque_noir;
]

let () = Alcotest.run "Mat et Pat" [
  "Pat", pat;
  "Roque", roque
]