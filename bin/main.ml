open OChess
open Affichage
open Partie
open ReglesBasiques
open Piece
open Echiquier


let partie = ref  @@ init_partie ()

exception Mouvement_ambigu

(* let rec print_list printer = function
| [] -> print_newline ()
| h :: t -> printer h; print_list printer t *)

(* let print_couple (x,y) = 
  Printf.printf "(%d,%d)\n" x y *)

let case_depart_cav partie p pos = 
  let cases = (mouvement (partie.trait,p) pos)
  |> List.filter (fun (x,y) -> match partie.echiquier.(x).(y) with | Piece p' -> p' = (partie.trait,p) | _ -> false ) 
  in
    if List.length cases = 1 then List.nth cases 0
    else if List.length cases > 1 then raise Mouvement_ambigu
    else raise Mouvement_invalide

let case_depart_reste partie p pos = 
  let cases = filter_saute_pas partie.echiquier (inverse partie.trait) (mouvement_dir (partie.trait,p) pos)
  |> List.filter (fun pos' -> contient (partie.trait,p) partie.echiquier pos')  in 
  if List.length cases = 1 then List.nth cases 0
  else if List.length cases > 1 then raise Mouvement_ambigu
  else raise Mouvement_invalide

     
let case_depart_pion partie (x,y) = 
  let dy = if partie.trait = Blanc then 1 else -1 in
  if est_adversaire partie.trait partie.echiquier.${x,y} then 
    if x = 0 && contient (partie.trait,Pion ) partie.echiquier (x+1,y-dy) then (x+1,y-dy)
    else if x = 7 && contient (partie.trait,Pion ) partie.echiquier (x-1,y-dy) then (x-1,y-dy)
    else 
      let possibles =
        (if contient (partie.trait,Pion ) partie.echiquier (x+1,y-dy) then [(x+1,y-dy)] else []) @
      (if contient (partie.trait,Pion ) partie.echiquier (x-1,y-dy) then [(x-1,y-dy)] else [])
      in
      if List.length possibles = 2 then raise Mouvement_ambigu else if List.length possibles = 0 then raise Mouvement_invalide else List.hd possibles
  else 
    if contient (partie.trait,Pion ) partie.echiquier (x,y-dy) then (x,y-dy) 
    else if contient (partie.trait,Pion ) partie.echiquier (x,y-2*dy) then (x,y-2*dy)
    else raise Mouvement_invalide


let case_depart partie p pos =
  match p with 
  | Cavalier -> case_depart_cav partie p pos
  | Pion -> case_depart_pion partie pos 
  | _ -> case_depart_reste partie p pos 

let parse_coup partie coup = 
  let p,(x,y) = from_algebrique coup in
  case_depart partie p (x,y),(x,y)

let () = 
  while not (ReglesBasiques.terminee !partie) do
    let () = print_string @@ string_of_echiquier ~couleur:false (!partie).echiquier in 
    let coup = read_line () in
    let dep,arr = parse_coup !partie coup in
    partie := match jouer !partie dep arr with
      | Some p -> p 
      | None -> (print_endline "Ce coup est illégal"; !partie)
  done





(* CONVENTION : la case e1 se note (4,0) *)