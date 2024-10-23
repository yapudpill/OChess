open OChess
open Affichage

(*** Test d'affichage (cf testAffichage.expected) ***)
let e = Echiquier.init_echiquier ()

let () =
  print_endline "~~~ Affichage sans couleurs ~~~\n";
  print_echiquier ~couleur:false e;
  print_endline "~~~ Affichage avec couleurs sans argument optionnel ~~~\n";
  print_echiquier e;
  print_endline "~~~ Affichage avec couleurs avec argument optionnel ~~~\n";
  print_echiquier ~couleur:true e