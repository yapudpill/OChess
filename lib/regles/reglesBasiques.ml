open Jeu.Piece
open Jeu.Echiquier
open Jeu.Partie

(*** Gestion des sauts et mouvements spéciaux (pion et cavalier) ***)

let filter_saute_pas echiquier couleur coups_dir =
  let rec filter acc = function
  | [] ->  acc
  | h :: t ->
    begin match echiquier.${h} with
    | None -> filter (h :: acc) t
    | Some (c, _) -> if c <> couleur then h :: acc else acc
    end
  in
  List.map (filter []) coups_dir

let deplacements_legaux_pion partie couleur ((x, _) as dep) =
  let n = Option.value partie.prise_en_passant ~default:(-1,-1) in
  let pep = if n = (-1,-1) then [[]] else [[n]] in
  pep @
  (mouv_pion_dir couleur dep
  |> List.map @@ List.filter (fun (x', y') ->
      match partie.echiquier.${x', y'} with
      | None -> x = x'
      | Some (c, _) -> x <> x' && c <> couleur) )

let deplacements_legaux_cavalier echiquier couleur dep =
  mouv_cav_dir dep
  |> List.map @@ List.filter (fun arr -> est_vide_ou_adversaire couleur echiquier.${arr})

let deplacements_legaux_dir partie piece dep =
  match piece with
  | (c, Pion) -> deplacements_legaux_pion partie c dep
  | (c, Cavalier) -> deplacements_legaux_cavalier partie.echiquier c dep
  | (c, p) -> filter_saute_pas partie.echiquier c (mouvement_dir (c, p) dep)

let deplacements_legaux echiquier piece dep =
  List.concat (deplacements_legaux_dir echiquier piece dep)



(*** Gestions des échecs ***)

(** [couleur] correspond à la couleur défendant la case [pos]. *)
let attaquee_dir partie couleur pos =
  List.concat_map (fun p ->
    deplacements_legaux_dir partie (couleur, p) pos
    |> List.filter (List.exists (contient partie.echiquier (inverse couleur, p)))
  ) [ Roi; Dame; Fou; Tour; Cavalier; Pion ]

(** [couleur] correspond à la couleur défendant la case [pos]. *)
let est_attaquee echiquier couleur pos = attaquee_dir echiquier couleur pos <> []




(*** Recherche de la case de départ 1 ***)

let case_depart_autre partie p pos =
  deplacements_legaux partie (inverse partie.trait, p) pos
  |> List.filter (contient partie.echiquier (partie.trait, p))


let case_depart_pion partie (x,y) =
  if Option.fold partie.prise_en_passant ~none:false ~some:((=) (x, y))
    || est_adversaire partie.trait partie.echiquier.${x,y} then
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



(*** Obtention des coups légaux ***)

let deplacer_piece partie ((x, y) as dep) ( (x', y') as arr)  =
  let echiquier = Array.map Array.copy partie.echiquier in
  echiquier.${arr} <- echiquier.${dep};
  echiquier.${dep} <- None;

  (* Prendre en passant *)
  if Option.fold partie.prise_en_passant ~none:false ~some:((=) arr) then begin
    match echiquier.${arr} with
    | Some (Blanc, Pion) -> echiquier.${x', y' - 1} <- None
    | Some (Noir, Pion)  -> echiquier.${x', y' + 1} <- None
    | _ -> ()
  end;

  (* Avance de 2 case *)
  let prise_en_passant = match echiquier.${arr} with
    | Some (Blanc, Pion) -> if y' = y + 2 then Some (x, y+1) else None
    | Some (Noir, Pion)  -> if y' = y - 2 then Some (x, y-1) else None
    | _ -> None
  in

  (* Promotion *)
  begin match echiquier.${arr} with
    | Some (Blanc, Pion) -> if y' = 7 then echiquier.${arr} <- Some (Blanc, Dame)
    | Some (Noir, Pion) -> if y' = 0 then echiquier.${arr} <- Some (Noir, Dame)
    | _ -> ()
  end;

  (* Roque *)
  let (g, d) = get_roque partie partie.trait in
  let partie = match echiquier.${arr} with
  | Some (_, Roi) -> set_pos_roi partie.trait arr partie
  | Some (_, Tour) -> set_roque partie.trait (x <> 0 && g, x <> 7 && d) partie
  | _ -> partie
  in

  { partie with
    echiquier;
    trait = inverse partie.trait;
    prise_en_passant
  }

let coups_legaux partie dep =
  match partie.echiquier.${dep} with
  | None -> []
  | Some (c, p) ->
    if c <> partie.trait then []
    else
      deplacements_legaux partie (c, p) dep
      |> List.filter (fun arr ->
        let partie = deplacer_piece partie dep arr in
        not @@ est_attaquee partie c (get_pos_roi partie c))

let est_legal partie dep arr = List.mem arr (coups_legaux partie dep)



(*** Gestion du roque ***)

let peut_roquer partie  type_roque =
  if not @@ peut_roquer_sans_echec partie type_roque || est_attaquee partie partie.trait (get_pos_roi partie partie.trait) then false
  else
    let (x,y) = get_pos_roi partie partie.trait in
    not @@ est_attaquee partie partie.trait (x + type_roque, y)
    && not @@ est_attaquee partie partie.trait (x+2*type_roque,y)
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



(*** Recherche de la case de départ 2 ***)

let case_depart partie p arr =
  let potentiels = match p with
  | Pion -> case_depart_pion partie arr
  | _ -> case_depart_autre partie p arr in
  List.filter (fun dep ->
    let c = partie.trait in
    let partie = deplacer_piece partie dep arr in
    not @@ est_attaquee partie c (get_pos_roi partie c)
  ) potentiels



(*** Jouer un coup ***)

let jouer partie dep arr =
  if est_legal partie dep arr then Some (deplacer_piece partie dep arr )
  else None



(*** Fin de partie ***)

let pat partie =
  not (est_attaquee partie partie.trait (get_pos_roi partie partie.trait)) &&
  let pat = ref true in
  for x = 0 to 7 do
    for y = 0 to 7 do
      pat := !pat && coups_legaux partie (x,y) = []
    done
  done;
  !pat

let mat partie =
  let roi = get_pos_roi partie partie.trait in
  let a_defendre = attaquee_dir partie partie.trait roi in
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
