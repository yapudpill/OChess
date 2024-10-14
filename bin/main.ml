open Echiquier


let e = inititialisation ()

let () =
  afficher_echiquier  e;
  let _ = deplacer_piece e (5,1) (5,2) in
  let _ = deplacer_piece e (4,6) (4,4) in
  let _ = deplacer_piece e (6,1) (6,3) in
  let _ = deplacer_piece e (3,7) (7,3) in
  let _ = deplacer_piece e (0,1) (0,2) in
  print_newline ();
  print_newline ();
  afficher_echiquier  e


(* 
CONVENTION : la case e1 se note (4,0)


*)