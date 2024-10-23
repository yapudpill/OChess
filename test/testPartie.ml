open OChess

let test_peut_roquer_sans_echec fen type_roque attendu =
  Alcotest.(check bool) fen attendu (Partie.peut_roquer_sans_echec (Fen.creer_partie_fen fen) type_roque)

let test_pos_roi fen attendu =
  let partie = Fen.creer_partie_fen fen in
  Alcotest.(check @@ pair int int) fen attendu (Partie.pos_roi partie partie.trait)


let roque_blanc () =
  test_peut_roquer_sans_echec "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R w KQkq" 1 true;
  test_peut_roquer_sans_echec "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R w KQkq" (-1) true;
  test_peut_roquer_sans_echec "r1bqk2r/pppp1ppp/2n2n2/8/1bBPP3/5N2/PP3PPP/RNBQ1K1R w kq" 1 false;
  test_peut_roquer_sans_echec "r1bqk2r/pppp1ppp/2n2n2/8/1bBPP3/5N2/PP3PPP/RNBQ1K1R w kq" (-1) false;
  test_peut_roquer_sans_echec "2rqkb1r/1p1bpppp/p1np1n2/8/3NP3/2N1B3/PPP1BPPP/R2Q1RK1 w k" 1 false;
  test_peut_roquer_sans_echec "2rqkb1r/1p1bpppp/p1np1n2/8/3NP3/2N1B3/PPP1BPPP/R2Q1RK1 w k" (-1) false

let roque_noir () =
  test_peut_roquer_sans_echec "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R b KQkq" 1 true;
  test_peut_roquer_sans_echec "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R b KQkq" (-1) true;
  test_peut_roquer_sans_echec "r1bqk2r/pppp1ppp/2n2n2/8/1bBPP3/5N2/PP3PPP/RNBQ1K1R b kq" 1 true;
  test_peut_roquer_sans_echec "r1bqk2r/pppp1ppp/2n2n2/8/1bBPP3/5N2/PP3PPP/RNBQ1K1R b kq" (-1) true;
  test_peut_roquer_sans_echec "2rqkb1r/1p1bpppp/p1np1n2/8/3NP3/2N1B3/PPP1BPPP/R2Q1RK1 b k" 1 true;
  test_peut_roquer_sans_echec "2rqkb1r/1p1bpppp/p1np1n2/8/3NP3/2N1B3/PPP1BPPP/R2Q1RK1 b k" (-1) false



let pos_roi_blanc () =
    test_pos_roi "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq" (4,7);
    test_pos_roi "r1bqk2r/pppp1ppp/2n2n2/1Bb1N3/4P3/8/PPPP1PPP/RNBQ1RK1 w kq" (6,0);
    test_pos_roi "r1bq3r/pppp1ppp/2n2n1k/1Bb1N3/2K1P3/8/PPPP1PPP/RNBQ1R2 w -" (2,3)

let pos_roi_noir () =
  test_pos_roi "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq" (4,0);
  test_pos_roi "r1bqk2r/pppp1ppp/2n2n2/1Bb1N3/4P3/8/PPPP1PPP/RNBQ1RK1 b kq" (4,7);
  test_pos_roi "r1bq3r/pppp1ppp/2n2n1k/1Bb1N3/2K1P3/8/PPPP1PPP/RNBQ1R2 b -" (7,5)


let roque = [
  "Roque blanc sans echec", `Quick, roque_blanc;
  "Roque noir sans echec", `Quick, roque_noir
]

let pos_roi = [
  "Position roi blanc", `Quick, pos_roi_blanc;
  "Position roi noir", `Quick, pos_roi_noir
]

let () = Alcotest.run "Mat et Pat" [
  "Roque", roque;
  "Position roi noir", pos_roi
]