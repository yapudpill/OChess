open OChess
open Affichage

(*** Test d'affichage (cf testAffichage.expected) ***)
let e = Fen.from_fen "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R"

let () =
  print_endline "~~~ Affichage sans couleurs ~~~\n";
  print_echiquier ~couleur:false e;
  print_endline "~~~ Affichage avec couleurs sans argument optionnel ~~~\n";
  print_echiquier e;
  print_endline "~~~ Affichage avec couleurs avec argument optionnel ~~~\n";
  print_echiquier ~couleur:true e