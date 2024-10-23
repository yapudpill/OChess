open OChess



let test_peut_roquer_sans_echec fen type_roque attendu =
  Alcotest.(check bool) fen attendu (Partie.peut_roquer_sans_echec (Fen.creer_partie_fen fen) type_roque)

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

let roque = [
  "Roque blanc sans echec", `Quick, roque_blanc;
  "Roque noir sans echec", `Quick, roque_noir
]

let () = Alcotest.run "Mat et Pat" [
  "Roque", roque
]