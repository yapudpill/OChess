open Piece
open Echiquier
open Partie

exception Mouvement_invalide

(* Attention, renverse les listes contenues dans coups_dir *)
let filter_saute_pas echiquier couleur coups_dir =
  let rec filter acc = function
  | [] ->  acc
  | (x, y) :: t ->
    begin match echiquier.(x).(y) with
    | Vide -> filter ((x, y) :: acc) t
    | Piece (c, _) -> if c <> couleur then (x, y) :: acc else acc
    end
  in
  List.concat @@ List.map (filter []) coups_dir


let coups_legaux_pion echiquier couleur ((x, _) as dep) =
  mouv_pion couleur dep
  |> List.filter (fun (x', y') ->
      match echiquier.(x').(y') with
      | Vide -> x = x'
      | Piece (c, _) -> x <> x' && c <> couleur)

let coups_legaux_cavalier echiquier couleur dep =
  mouv_cav dep
  |> List.filter (fun (x, y) -> est_vide_ou_adversaire couleur echiquier.(x).(y))

let coups_legaux partie ((x, y) as dep) =
  let e = partie.echiquier in
  match partie.echiquier.(x).(y) with
  | Vide -> []
  | Piece (c, _) when c <> partie.trait -> []
  | Piece (c, Pion) -> coups_legaux_pion e c dep
  | Piece (c, Cavalier) -> coups_legaux_cavalier e c dep
  | Piece (c, p) -> filter_saute_pas e c (mouvement_dir (c, p) dep)

let est_legal partie dep arr = List.mem arr @@ coups_legaux partie dep

let deplacer_piece partie (x,y) (x',y') =
  let e = partie.echiquier in
  if est_legal partie (x,y) (x',y')
    then (e.(x').(y') <- e.(x).(y); e.(x).(y) <- Vide; {partie with trait = inverse partie.trait})
    else raise Mouvement_invalide
