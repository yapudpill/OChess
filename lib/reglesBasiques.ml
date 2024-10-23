open Piece
open Echiquier
open Partie

exception Mouvement_invalide

(* Gestion des sauts et mouvements spéciaux (pion et cavalier) *)

let filter_saute_pas echiquier couleur coups_dir =
  let rec filter acc = function
  | [] ->  acc
  | h :: t ->
    begin match echiquier.${h} with
    | Vide -> filter (h :: acc) t
    | Piece (c, _) -> if c <> couleur then h :: acc else acc
    end
  in
  List.concat @@ List.map (filter []) coups_dir

let deplacements_legaux_pion echiquier couleur ((x, _) as dep) =
  mouv_pion couleur dep
  |> List.filter (fun (x', y') ->
      match echiquier.${x', y'} with
      | Vide -> x = x'
      | Piece (c, _) -> x <> x' && c <> couleur)

let deplacements_legaux_cavalier echiquier couleur dep =
  mouv_cav dep
  |> List.filter (fun arr -> est_vide_ou_adversaire couleur echiquier.${arr})

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

let deplacer_piece partie ((x, _) as dep) arr =
  let echiquier = Array.map Array.copy partie.echiquier in
  echiquier.${arr} <- echiquier.${dep};
  echiquier.${dep} <- Vide;

  let (tgb, rb, tdb), (tgn, rn, tdn) = partie.roque_blanc, partie.roque_noir in
  let roi_blanc, roi_noir, roque_blanc, roque_noir = match echiquier.${arr} with
  | Piece (Blanc, Roi) -> arr, partie.roi_noir, (tgb, false, tdb), (tgn, rn, tdn)
  | Piece (Noir, Roi)  -> partie.roi_blanc, arr, (tgb, rb, tdb), (tgn, false, tdn)
  | Piece (Blanc, Tour) -> let tgb, tdb = (x = 0 || tgb, x = 7 || tdb) in partie.roi_blanc, partie.roi_noir, (tgb, rb, tdb), (tgn, rn, tdn)
  | Piece (Noir, Tour)  -> let tgn, tdn = (x = 0 || tgn, x = 7 || tdn) in partie.roi_blanc, partie.roi_noir, (tgb, rb, tdb), (tgn, rn, tdn)
  | _ -> partie.roi_blanc, partie.roi_noir, (tgb, rb, tdb), (tgn, rn, tdn)
  in
  {echiquier; roi_blanc; roi_noir; trait = inverse partie.trait; roque_blanc; roque_noir}

let coups_legaux partie dep =
  match partie.echiquier.${dep} with
  | Vide -> []
  | Piece (c, p) ->
    if c <> partie.trait then []
    else
      deplacements_legaux partie.echiquier (c, p) dep
      |> List.filter (fun arr ->
        let partie = deplacer_piece partie dep arr in
        not @@ est_attaquee partie.echiquier c (Partie.pos_roi partie c))

let est_legal partie dep arr = List.mem arr (coups_legaux partie dep)

let jouer partie dep ((_, y) as arr) =
  if est_legal partie dep arr then
    let partie = deplacer_piece partie dep arr in
    let e = partie.echiquier in
    begin match e.${arr} with
    | Piece (Blanc, Pion) -> if y = 7 then e.${arr} <- Piece (Blanc, Dame)
    | Piece (Noir, Pion) -> if y = 0 then e.${arr} <- Piece (Noir, Dame)
    | _ -> ()
    end;
    Some partie
  else None


(* Gestion du mat pat*)

let parable partie (x',y') =
    let x,y = pos_roi partie partie.trait in
    let dx = (if x'-x = 0 then 0 else if x'-x < 0 then -1 else 1) in
    let dy = (if y'-y = 0 then 0 else if y'-y < 0 then -1 else 1) in
    let rec aux k =
      if  (dx = 1 && dy = 1) && (x + k*dx > x' || y + k*dy > y') then false else
      if  (dx = 1 && dy = -1) && (x + k*dx > x' || y + k*dy < y') then false else
      if  (dx = -1 && dy = 1) && (x + k*dx < x' || y + k*dy > y') then false else
      if  (dx = -1 && dy = -1 && x + k*dx < x' || y + k*dy < y') then false else
      if est_attaquee partie.echiquier (inverse partie.trait) (x + k*dx, y + k*dy) then true else
          aux (k+1)
    in aux 1

let mat partie pos =
  let roi = pos_roi partie partie.trait in
    est_attaquee partie.echiquier (inverse partie.trait) roi
    && coups_legaux partie roi |> List.is_empty
    && not @@ parable partie pos

let pat partie =
  let roi = pos_roi partie partie.trait in
    let ref = ref true in
    for x = 0 to 7 do
      for y = 0 to 7 do
        ref := !ref && coups_legaux partie (x,y) = []
      done
    done;
    !ref &&  not @@ est_attaquee partie.echiquier partie.trait roi

let trouver_echec partie = partie.roi_blanc

(* Gestion du roque*)

let peut_roquer partie  type_roque=
  if not @@ peut_roquer_sans_echec partie type_roque  || est_attaquee partie.echiquier partie.trait (pos_roi partie partie.trait) then false
  else
    let (x,y) = pos_roi partie partie.trait in
    not @@ est_attaquee partie.echiquier partie.trait (x+type_roque,y)
    && est_vide partie.echiquier.${(x+type_roque,y)}
    && not @@ est_attaquee partie.echiquier partie.trait (x+2*type_roque,y)
    && est_vide partie.echiquier.${(x+2*type_roque,y)}

let roque partie type_roque=
    if not @@ peut_roquer partie type_roque then raise Mouvement_invalide
    else
      let partie = match partie.trait with
      | Blanc -> { partie with roque_blanc = false,false,false}
      | Noir -> { partie with roque_noir = false,false,false}
      in
      let x_tour = (if type_roque = 1 then 7 else 0) in
      let (x,y) = pos_roi partie partie.trait in
      let partie = deplacer_piece partie (x,y) (x+ 2*type_roque,y) in
      let partie = deplacer_piece partie  (x_tour,y) (x+ 2*type_roque -type_roque,y) in
      {partie with trait = inverse partie.trait}

let terminee partie =
    mat partie (trouver_echec partie) || pat partie