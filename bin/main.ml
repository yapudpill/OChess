open OChess
open ReglesBasiques
open Echiquier
open Affichage

let partie = ref @@ Fen.creer_partie_fen "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -"

let () =
  print_endline "\027[H\027[J";
  while not (terminee !partie) do
    print_echiquier ~couleur:false (!partie).echiquier;
    Printf.printf "Trait : %s\n" (string_of_couleur !partie.trait);

    Printf.printf "Votre coup > ";
    let coup = read_line () in

    print_string "\027[H\027[J";

    partie := begin match Algebrique.from_algebrique coup with
    | None -> print_endline "Ce coup est invalide"; !partie
    | Some Petit_roque -> (match roque !partie 1 with
      | None -> print_endline "Ce coup est illégal"; !partie
      | Some p -> p)
    | Some Grand_roque -> (match roque !partie (-1) with
      | None -> print_endline "Ce coup est illégal"; !partie
      | Some p -> p)
    | Some (Mouvement (p,arr)) -> (
      match case_depart !partie p arr with
      | [] -> print_endline "Ce coup est illégal"; !partie
      | _ :: _ :: _ -> print_endline "Ce coup est ambigu"; !partie
      | [ dep ] -> (
        match jouer !partie dep arr with
        | Some p -> print_newline (); p
        | None -> print_endline "Ce coup est illégal"; !partie
        )
      )
    end
  done