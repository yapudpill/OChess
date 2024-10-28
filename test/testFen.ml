open EntreeSortie

let test_car_invalide () =
  Alcotest.check_raises "Caractère non valide" (Failure "Caractère non valide")
    (fun () -> ignore @@ Fen.creer_partie_fen "rnbqkbnv/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq")

let test_pas_roi () =
  Alcotest.check_raises "Pas roi blanc" (Failure "FEN invalide")
    (fun () -> ignore @@ Fen.creer_partie_fen "8/8/8/8/8/8/8/8 w -");
  Alcotest.check_raises "Pas roi noir" (Failure "FEN invalide")
    (fun () -> ignore @@ Fen.creer_partie_fen "8/8/8/8/8/8/8/K7 w - ")

let test_fen = [
  "Caractère invalide", `Quick, test_car_invalide;
  "Pas de roi", `Quick, test_pas_roi
]

let () = Alcotest.run "FEN" [
  "FEN", test_fen
]