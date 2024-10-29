open Regles.ReglesBasiques
open EntreeSortie
open Affichage

let partie = ref @@ Fen.creer_partie_fen "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -"

let () =
  print_endline "\027[H\027[J";

  while not (terminee !partie) do
    print_echiquier ~couleur:false (!partie).echiquier;
    Printf.printf "Trait : %s\n" (string_of_couleur !partie.trait);

    Printf.printf "Votre coup > ";
    let str = read_line () in

    print_string "\027[H\027[J";

    match Algebrique.from_string str with
    | None -> print_endline "Entrée invalide"
    | Some algebrique ->
      begin match coup_of_algebrique !partie algebrique with
      | Ok coup -> partie := jouer !partie coup; print_newline ()
      | Error Invalide -> print_endline "Ce coup est invalide"
      | Error (Ambigu _) -> print_endline "Ce coup est ambigu"
      end
  done