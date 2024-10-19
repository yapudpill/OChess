open OChess
open Affichage
open Partie
open ReglesBasiques
open Piece
open Echiquier


let partie = ref  @@ init_partie ()

exception Mouvement_ambigu



(*
let print_coup coup =
  match coup with
  | Petit_roque -> print_endline "O-O"
  | Grand_roque -> print_endline "O-O-O"
  | Mouvement (p,(x,y)) -> print_char (char_of_piece p); Printf.printf "(%d,%d)\n" x y *)

let case_depart_autre partie p pos =
    let cases = deplacements_legaux partie.echiquier (inverse partie.trait,p) pos
    |> List.filter (fun pos' -> contient (partie.trait,p) partie.echiquier pos') in
    if List.length cases = 1 then List.nth cases 0
    else if List.length cases > 1 then raise Mouvement_ambigu
    else raise Mouvement_invalide


let case_depart_pion partie (x,y) =
  let dy = if partie.trait = Blanc then -1 else 1 in
  if est_adversaire partie.trait partie.echiquier.${x,y} then
    if x = 0 && contient (partie.trait,Pion ) partie.echiquier (x+1,y+dy) then (x+1,y+dy)
    else if x = 7 && contient (partie.trait,Pion ) partie.echiquier (x-1,y+dy) then (x-1,y+dy)
    else
      let possibles =
        (if contient (partie.trait,Pion ) partie.echiquier (x+1,y+dy) then [(x+1,y+dy)] else []) @
      (if contient (partie.trait,Pion ) partie.echiquier (x-1,y+dy) then [(x-1,y+dy)] else [])
      in
      if List.length possibles = 2 then raise Mouvement_ambigu else if List.length possibles = 0 then raise Mouvement_invalide else List.hd possibles
  else
    if contient (partie.trait,Pion ) partie.echiquier (x,y+dy) then (x,y+dy)
    else if contient (partie.trait,Pion ) partie.echiquier (x,y+2*dy) then (x,y+2*dy)
    else raise Mouvement_invalide


let case_depart partie p pos =
  match p with
  | Pion -> case_depart_pion partie pos
  | _ -> case_depart_autre partie p pos

let parse_coup partie p arr =
  case_depart partie p arr



let () =
  while not (ReglesBasiques.terminee !partie) do
    let () = print_string @@ string_of_echiquier ~couleur:false (!partie).echiquier in
    let coup = read_line () in
    partie :=
    match from_algebrique coup with
    | Petit_roque -> roque !partie 1
    | Grand_roque -> roque !partie (-1)
    | Mouvement (p,arr) -> (let dep = parse_coup !partie p arr in
        match jouer !partie dep arr with
        | Some p -> p
        | None -> (print_endline "Ce coup est illégal"; !partie))
  done