open OChess
open Affichage
open Partie
open ReglesBasiques
open Echiquier

let partie = ref @@ Fen.creer_partie_fen "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq"

let () =
  while not (ReglesBasiques.terminee !partie) do
    let () = print_echiquier ~couleur:false (!partie).echiquier in
    let coup = read_line () in
    partie :=
    match Algebrique.from_algebrique coup with
    | None -> print_endline "Ce coup est invalide"; !partie
    | Some Petit_roque -> (match roque !partie 1 with
      | None -> print_endline "Ce coup est illégal"; !partie
      | Some p -> p)
    | Some Grand_roque -> (match roque !partie (-1) with
      | None -> print_endline "Ce coup est illégal"; !partie
      | Some p -> p)
    | Some (Mouvement (p,arr)) -> (
      match ReglesBasiques.case_depart !partie p arr with
      | [] -> (print_endline "Ce coup est illégal"; !partie)
      | _ :: _ :: _ -> (print_endline "Ce coup est ambigu"; !partie)
      | [ dep ] -> (
        match jouer !partie dep arr with
        | Some p -> p
        | None -> (print_endline "Ce coup est illégal"; !partie)
        )
      )
  done