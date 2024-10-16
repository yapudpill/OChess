open OChess
open Affichage
open Partie
open ReglesBasiques

let joue_affiche p dep arr =
  let p = jouer p dep arr in
  print_endline (string_of_echiquier ~couleur:false p.echiquier);
  p

let p = init_partie ()

let () = print_endline @@ string_of_echiquier p.echiquier
let p = joue_affiche p (4,1) (4,3)
let p = joue_affiche p (4,6) (4,4)
let p = joue_affiche p (3,0) (5,2)
let p = joue_affiche p (0,6) (0,5)
let p = joue_affiche p (5,2) (5,6)
let _ = joue_affiche p (4,7) (5,6)
(* let _ = joue_affiche p (5,7) (4,6) *)


(* CONVENTION : la case e1 se note (4,0) *)