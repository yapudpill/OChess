open Piece
open Echiquier
open Partie

exception Mouvement_invalide

(*** Gestion des sauts et mouvements spéciaux (pion et cavalier) ***)

let filter_saute_pas echiquier couleur coups_dir =
  let rec filter acc = function
  | [] ->  acc
  | h :: t ->
    begin match echiquier.${h} with
    | Vide -> filter (h :: acc) t
    | Piece (c, _) -> if c <> couleur then h :: acc else acc
    end
  in
  List.map (filter []) coups_dir

let deplacements_legaux_pion echiquier couleur ((x, _) as dep) =
  mouv_pion_dir couleur dep
  |> List.map @@ List.filter (fun (x', y') ->
      match echiquier.${x', y'} with
      | Vide -> x = x'
      | Piece (c, _) -> x <> x' && c <> couleur)

let deplacements_legaux_cavalier echiquier couleur dep =
  mouv_cav_dir dep
  |> List.map @@ List.filter (fun arr -> est_vide_ou_adversaire couleur echiquier.${arr})

let deplacements_legaux_dir echiquier piece dep =
  match piece with
  | (c, Pion) -> deplacements_legaux_pion echiquier c dep
  | (c, Cavalier) -> deplacements_legaux_cavalier echiquier c dep
  | (c, p) -> filter_saute_pas echiquier c (mouvement_dir (c, p) dep)

let deplacements_legaux echiquier piece dep =
  List.concat (deplacements_legaux_dir echiquier piece dep)



(*** Gestions des échecs ***)

(** [couleur] correspond à la couleur défendant la case [pos]. *)
let attaquee_dir echiquier couleur pos =
  List.concat_map (fun p ->
    deplacements_legaux_dir echiquier (couleur, p) pos
    |> List.filter (List.exists (contient echiquier (inverse couleur, p)))
  ) [ Roi; Dame; Fou; Tour; Cavalier; Pion ]

(** [couleur] correspond à la couleur défendant la case [pos]. *)
let est_attaquee echiquier couleur pos = attaquee_dir echiquier couleur pos <> []



(*** Obtention des coups légaux ***)

let deplacer_piece partie ((x, _) as dep) arr =
  let echiquier = Array.map Array.copy partie.echiquier in
  echiquier.${arr} <- echiquier.${dep};
  echiquier.${dep} <- Vide;

  let (g, d) = get_roque partie partie.trait in
  let partie = match echiquier.${arr} with
  | Piece (_, Roi) -> set_pos_roi partie.trait arr partie
  | Piece (_, Tour) -> set_roque partie.trait (x <> 0 && g, x <> 7 && d) partie
  | _ -> partie
  in { partie with echiquier; trait = inverse partie.trait }

let coups_legaux partie dep =
  match partie.echiquier.${dep} with
  | Vide -> []
  | Piece (c, p) ->
    if c <> partie.trait then []
    else
      deplacements_legaux partie.echiquier (c, p) dep
      |> List.filter (fun arr ->
        let partie = deplacer_piece partie dep arr in
        not @@ est_attaquee partie.echiquier c (get_pos_roi partie c))

let est_legal partie dep arr = List.mem arr (coups_legaux partie dep)



(*** Gestion du roque ***)

let peut_roquer partie  type_roque =
  if not @@ peut_roquer_sans_echec partie type_roque || est_attaquee partie.echiquier partie.trait (get_pos_roi partie partie.trait) then false
  else
    let (x,y) = get_pos_roi partie partie.trait in
    not @@ est_attaquee partie.echiquier partie.trait (x + type_roque, y)
    && not @@ est_attaquee partie.echiquier partie.trait (x+2*type_roque,y)
    && est_vide partie.echiquier.${(x+type_roque,y)}
    && est_vide partie.echiquier.${(x+2*type_roque,y)}

let roque partie type_roque=
  if not @@ peut_roquer partie type_roque then None
  else
    let x_tour = (if type_roque = 1 then 7 else 0) in
    let (x,y) = get_pos_roi partie partie.trait in
    let partie = deplacer_piece partie (x,y) (x+ 2*type_roque,y) in
    let partie = {partie with trait = inverse partie.trait} in
    Some (deplacer_piece partie  (x_tour,y) (x+ 2*type_roque -type_roque,y))



(*** Recherche de la case de départ ***)

let case_depart_autre partie p pos =
  deplacements_legaux partie.echiquier (inverse partie.trait, p) pos
  |> List.filter (contient partie.echiquier (partie.trait, p))

let case_depart_pion partie (x,y) =
  if est_adversaire partie.trait partie.echiquier.${x,y} then
    case_depart_autre partie Pion (x, y)
  else
    match partie.trait with
    | Blanc ->
      if y > 0 && contient partie.echiquier (partie.trait, Pion) (x, y-1) then [(x, y-1)]
      else if y = 3 && contient partie.echiquier (partie.trait, Pion) (x, y-2) then [(x, y-2)]
      else []
    | Noir ->
      if y < 7 && contient partie.echiquier (partie.trait, Pion) (x, y+1) then [(x, y+1)]
      else if y = 4 && contient partie.echiquier (partie.trait, Pion) (x, y+2) then [(x, y+2)]
      else []

let case_depart partie p arr =
  let potentiels = match p with
  | Pion -> case_depart_pion partie arr
  | _ -> case_depart_autre partie p arr in
  List.filter (fun dep ->
    let partie = deplacer_piece partie dep arr in
    not @@ est_attaquee partie.echiquier partie.trait (get_pos_roi partie partie.trait)
  ) potentiels



(*** Jouer un coup ***)

let jouer partie dep ((_, y) as arr) =
  if est_legal partie dep arr then
    let partie = deplacer_piece partie dep arr in
    (* Promotion *)
    begin match partie.echiquier.${arr} with
    | Piece (Blanc, Pion) -> if y = 7 then partie.echiquier.${arr} <- Piece (Blanc, Dame)
    | Piece (Noir, Pion) -> if y = 0 then partie.echiquier.${arr} <- Piece (Noir, Dame)
    | _ -> ()
    end;
    Some partie
  else None



(*** Fin de partie ***)

let pat partie =
  not (est_attaquee partie.echiquier partie.trait (get_pos_roi partie partie.trait)) &&
  let pat = ref true in
  for x = 0 to 7 do
    for y = 0 to 7 do
      pat := !pat && coups_legaux partie (x,y) = []
    done
  done;
  !pat

let mat partie =
  let roi = get_pos_roi partie partie.trait in
  let a_defendre = attaquee_dir partie.echiquier partie.trait roi in
  match a_defendre with
  | [] -> false
  | _ :: _ :: _ -> coups_legaux partie roi = []
  | [ dir ] ->
    coups_legaux partie roi = [] &&
    let mat = ref true in
    for x = 0 to 7 do
      for y = 0 to 7 do
        mat := !mat && not @@ List.exists (fun x -> List.mem x dir) (coups_legaux partie (x,y))
      done
    done;
    !mat

let terminee partie = pat partie || mat partie
