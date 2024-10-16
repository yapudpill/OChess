open Piece
open Echiquier
open Partie

exception Mouvement_invalide

(* Gestion des sauts et mouvements spéciaux (pion et cavalier) *)

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


let deplacements_legaux_pion echiquier couleur ((x, _) as dep) =
  mouv_pion couleur dep
  |> List.filter (fun (x', y') ->
      match echiquier.(x').(y') with
      | Vide -> x = x'
      | Piece (c, _) -> x <> x' && c <> couleur)

let deplacements_legaux_cavalier echiquier couleur dep =
  mouv_cav dep
  |> List.filter (fun (x, y) -> est_vide_ou_adversaire couleur echiquier.(x).(y))


let deplacements_legaux echiquier piece dep =
  match piece with
  | (c, Pion) -> deplacements_legaux_pion echiquier c dep
  | (c, Cavalier) -> deplacements_legaux_cavalier echiquier c dep
  | (c, p) -> filter_saute_pas echiquier c (mouvement_dir (c, p) dep)


(* Gestions des échecs *)
let est_attaquee echiquier couleur pos =
  [ Roi; Dame; Fou; Tour; Cavalier; Pion ]
  |> List.exists (fun p ->
      let deps = deplacements_legaux echiquier (couleur, p) pos in
      List.exists (fun (x, y) -> contient (inverse couleur, p) echiquier (x, y)) deps
      )


(* Obtention des coups légaux *)
let deplacer_piece partie (x,y) (x',y') =
  let echiquier = Array.map Array.copy partie.echiquier in
  echiquier.(x').(y') <- echiquier.(x).(y);
  echiquier.(x).(y) <- Vide;
  let roi_blanc, roi_noir = match echiquier.(x').(y') with
  | Piece (Blanc, Roi) -> (x', y'), partie.roi_noir
  | Piece (Noir, Roi) -> partie.roi_blanc, (x', y')
  | _ -> partie.roi_blanc, partie.roi_noir
  in
  {echiquier; roi_blanc; roi_noir; trait = inverse partie.trait}

let coups_legaux partie ((x, y) as dep) =
  match partie.echiquier.(x).(y) with
  | Vide -> []
  | Piece (c, p) ->
    if c <> partie.trait then []
    else
      deplacements_legaux partie.echiquier (c, p) dep
      |> List.filter (fun arr ->
        let partie = deplacer_piece partie (x, y) arr in
        not @@ est_attaquee partie.echiquier c (Partie.pos_roi partie c))

let est_legal partie dep arr = List.mem arr (coups_legaux partie dep)

let jouer partie dep arr =
  if est_legal partie dep arr then deplacer_piece partie dep arr
  else raise Mouvement_invalide
