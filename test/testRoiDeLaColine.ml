open Regles.RoiDeLaColine


let test_perdu fen attendu =
  Alcotest.(check bool) fen attendu (perdu (init_pos fen))

let gain_blanc () =
  test_perdu "rnb1k1nr/pppp1ppp/8/1b2p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq -" false;
  test_perdu "rnb1k1nr/pppp1ppp/8/2b1p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq -" true;
  test_perdu "1kbnr/pppp1ppp/2n5/4p3/4P3/2N2N2/PPPP1qPP/R1BQKB1R w KQkq -" false;
  test_perdu "1r6/2r5/8/7k/8/8/8/1K6 w - -" false;
  test_perdu "r7/1r6/8/7k/8/8/K3B1q1/8 w - -" true;
  test_perdu "r7/1r6/8/7k/8/8/K3B3/6q1 w - -" false;
  test_perdu "8/4k3/8/2r3bb/8/8/1P6/1RK5 w - -" true;
  test_perdu "8/4k2N/8/2r3bb/8/8/1P6/1RK5 w - -" true;
  test_perdu "8/4kb1N/8/2r3b1/8/8/1P6/1RK5 w - -" false;
  test_perdu "1k6/8/8/8/8/8/r1r5/1K6 w - -" false;
  test_perdu "rnbqkb1r/ppp1pppp/5n2/3p4/4P3/3K4/PPPP1PPP/RNBQ1BNR w kq -" false;
  test_perdu "rnbqkb1r/ppp1pppp/5n2/3p4/3KP3/8/PPPP1PPP/RNBQ1BNR b kq -" true

let gain_noirs () =
  test_perdu "2k4R/8/2K5/8/8/8/8/8 b - -" true;
  test_perdu "2k5/4N3/1K1Q4/8/8/8/8/8 b - -" true;
  test_perdu "2k5/7R/2K5/8/8/8/8/8 b - -" false;
  test_perdu "2k5/8/1K1Q4/8/8/8/8/8 b - -" false

let fin = [
  "Gain blanc", `Quick, gain_blanc;
  "Gain noir", `Quick, gain_noirs
]

let () = Alcotest.run "Fin de partie Roi de la Coline" [
  "Fin de partie", fin;
]