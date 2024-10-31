open Jeu.Piece
open Jeu.Echiquier
open Jeu.Partie


type infos = unit
let string_of_infos _ = None

(*** Création d'une partie ***)
let init_pos fen =
  EntreeSortie.Fen.creer_partie_fen fen, ()

let init_partie () =
  init_pos "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -"


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
  Option.fold partie.en_passant ~none:[] ~some:(fun x -> [[x]]) @
  (mouv_pion_dir couleur dep
  |> List.map @@ List.filter (fun (x', y') ->
      match partie.echiquier.${x', y'} with
      | None -> x = x'
      | Some (c, _) -> x <> x' && c <> couleur))

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
let est_attaquee partie couleur pos = attaquee_dir partie couleur pos <> []

let echec partie =
  est_attaquee partie partie.trait (get_pos_roi partie partie.trait)



(*** Obtention des coups légaux ***)
let deplacer_piece partie ((x, y) as dep) ( (x', y') as arr)  =
  let echiquier = Array.map Array.copy partie.echiquier in
  echiquier.${arr} <- echiquier.${dep};
  echiquier.${dep} <- None;

  (* Prendre en passant *)
  if Option.fold partie.en_passant ~none:false ~some:((=) arr) then begin
    match echiquier.${arr} with
    | Some (Blanc, Pion) -> echiquier.${x', y' - 1} <- None
    | Some (Noir, Pion)  -> echiquier.${x', y' + 1} <- None
    | _ -> ()
  end;

  (* Avance de 2 case *)
  let en_passant = match echiquier.${arr} with
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
    en_passant
  }

let coups_legaux partie dep =
  match partie.echiquier.${dep} with
  | None -> []
  | Some (c, p) ->
    if c <> partie.trait then []
    else
      deplacements_legaux partie (c, p) dep
      |> List.filter (fun arr -> not @@ echec (deplacer_piece partie dep arr))

let est_legal partie dep arr = List.mem arr (coups_legaux partie dep)



(*** Gestion du roque ***)
let peut_roquer partie  type_roque =
  let (x,y) = get_pos_roi partie partie.trait in
  peut_roquer_sans_echec partie type_roque
  && not (echec partie)
  && est_vide partie.echiquier.${(x + type_roque, y)}
  && est_vide partie.echiquier.${(x + 2*type_roque, y)}
  && not @@ est_attaquee partie partie.trait (x + type_roque, y)
  && not @@ est_attaquee partie partie.trait (x + 2*type_roque, y)

let roque partie type_roque=
  if peut_roquer partie type_roque then
    let x_tour = (if type_roque = 1 then 7 else 0) in
    let (x,y) = get_pos_roi partie partie.trait in
    let partie = deplacer_piece partie (x,y) (x+ 2*type_roque,y) in
    let partie = deplacer_piece partie (x_tour,y) (x+ 2*type_roque -type_roque,y)in
    {partie with trait = inverse partie.trait}
  else failwith "roque"



(*** Interprétation de la notation algébrique ***)
let case_depart_autre partie p pos =
  deplacements_legaux partie (inverse partie.trait, p) pos
  |> List.filter (contient partie.echiquier (partie.trait, p))

let case_depart_pion partie (x,y) =
  if Option.fold partie.en_passant ~none:false ~some:((=) (x, y))
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

let coup_of_algebrique partie = function
| EntreeSortie.Algebrique.Placement _ -> Error Invalide
| EntreeSortie.Algebrique.Grand_Roque ->
  if peut_roquer partie (-1) then Ok Grand_Roque else Error Invalide
| EntreeSortie.Algebrique.Petit_Roque ->
  if peut_roquer partie 1 then Ok Petit_Roque else Error Invalide
| EntreeSortie.Algebrique.Arrivee (p, arr) ->
  let potentiels = match p with
  | Pion -> case_depart_pion partie arr
  | _ -> case_depart_autre partie p arr in
  let deps = List.filter (fun dep -> not @@ echec (deplacer_piece partie dep arr)) potentiels in
  match deps with
  | [] -> Error Invalide
  | [dep] -> Ok (Mouvement (dep, arr))
  | _ -> Error (Ambigu deps)



(*** Jouer un coup ***)
let jouer (partie, i) = function
| Grand_Roque -> roque partie 1, i
| Petit_Roque -> roque partie (-1), i
| Mouvement (dep, arr) ->
  if est_legal partie dep arr then
    let partie = deplacer_piece partie dep arr in
    {partie with trait = inverse partie.trait}, i
  else failwith "jouer"
| Placement _ -> failwith "jouer"



(*** Fin de partie ***)
let pat partie =
  not (echec partie) &&
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

let perdu (partie, ()) = mat partie
let egalite (partie, ()) = pat partie
