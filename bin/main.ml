open OChess
open Affichage
open Partie
open ReglesBasiques

let p = init_partie ()

let () = print_string @@ string_of_echiquier p.echiquier

let p = deplacer_piece p (3,1) (3,3)

let () =
  print_newline ();
  print_string @@ string_of_echiquier p.echiquier

let p = deplacer_piece p (4,6) (4,4)

let () =
  print_newline ();
  print_string @@ string_of_echiquier p.echiquier

let p = deplacer_piece p (3,3) (4,4)

let () =
  print_newline ();
  print_string @@ string_of_echiquier p.echiquier

let p = deplacer_piece p (3,7) (5,5)

let () =
  print_newline ();
  print_string @@ string_of_echiquier p.echiquier

let p = deplacer_piece p (4,4) (5,5)

let () =
  print_newline ();
  print_string @@ string_of_echiquier p.echiquier

(* CONVENTION : la case e1 se note (4,0) *)