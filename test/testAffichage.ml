open EntreeSortie.Affichage

(*** Test d'affichage (cf testAffichage.expected) ***)
let p =
  EntreeSortie.Fen.creer_partie_fen
    "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R w KQkq -"

let () =
  let e = p.echiquier in
  print_endline "~~~ Affichage sans couleurs ~~~\n";
  print_echiquier ~couleur:false e;
  Printf.printf "Trait : %s\n" (string_of_couleur p.trait);
  Printf.printf "Adversaire : %s\n\n" (string_of_couleur Noir);

  print_endline "~~~ Affichage avec couleurs sans argument optionnel ~~~\n";
  print_echiquier e;
  Printf.printf "Trait : %s\n" (string_of_couleur p.trait);
  Printf.printf "Adversaire : %s\n\n" (string_of_couleur Noir);

  print_endline "~~~ Affichage avec couleurs avec argument optionnel ~~~\n";
  print_echiquier ~couleur:true e;
  Printf.printf "Trait : %s\n" (string_of_couleur p.trait);
  Printf.printf "Adversaire : %s\n" (string_of_couleur Noir)
