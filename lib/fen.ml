open Piece
open Echiquier
open Partie



(* Fonction pour vérifier si un caractère représente un chiffre *)
let est_chiffre c =
  c >= '0' && c <= '9'

(* Fonction pour convertir un caractère en pièce (ptype, couleur) *)
let piece_of_char c =
  let couleur = if Char.uppercase_ascii c = c then Blanc else Noir in
  let ptype = match Char.lowercase_ascii c with
    | 'r' -> Tour
    | 'n' -> Cavalier
    | 'b' -> Fou
    | 'q' -> Dame
    | 'k' -> Roi
    | 'p' -> Pion
    | _ -> failwith "Caractère non valide"
  in
  Piece (couleur, ptype)

(* Fonction auxiliaire récursive *)
let rec from_fen_aux fen echiquier x y k =
  if k >= String.length fen then
    echiquier
  else
    let c = fen.[k] in
    if c = '/' then
      from_fen_aux fen echiquier 0 (y - 1) (k + 1)  (* Sauter à la rangée suivante *)
    else if est_chiffre c then
      let avance = int_of_char c - int_of_char '0' in
      from_fen_aux fen echiquier (x + avance) y (k + 1)  (* Sauter des cases vides *)
    else (
      echiquier.(x).(y) <- piece_of_char c;
      from_fen_aux fen echiquier (x + 1) y (k + 1)  (* Placer la pièce et passer à la case suivante *)
    )



let rec trouver_rois echiquier x y roi_blanc roi_noir =
  if x = 8 then (roi_blanc, roi_noir)
  else
    if y = 8 then trouver_rois echiquier (x + 1) 0 roi_blanc roi_noir
    else
      match echiquier.(x).(y) with
      | Piece (Blanc, Roi) -> trouver_rois echiquier (x + 1) 0 (x, y) roi_noir  (* Roi blanc trouvé *)
      | Piece (Noir, Roi) -> trouver_rois echiquier (x + 1) 0 roi_blanc (x, y)  (* Roi noir trouvé *)
      | _ -> trouver_rois echiquier x (y + 1) roi_blanc roi_noir  (* Continuer à chercher *)

(* Fonction principale from_fen *)
let from_fen (fen : string) =
  let echiquier = Array.init_matrix 8 8 (fun _ _ -> Vide) in
  from_fen_aux fen echiquier 0 7 0

(* Fonction pour convertir les droits de roque depuis le FEN *)
let roque_of_fen roque_str =
  let roque_blanc = (String.contains roque_str 'Q', String.contains roque_str 'K' || String.contains roque_str 'Q', String.contains roque_str 'K') in
  let roque_noir = (String.contains roque_str 'q', String.contains roque_str 'k' || String.contains roque_str 'q', String.contains roque_str 'k') in
  (roque_blanc, roque_noir)

(* Fonction principale pour créer une partie à partir d'une FEN *)
let creer_partie_fen (fen : string) =
  (* On découpe le FEN en différentes sections *)
  let parts = String.split_on_char ' ' fen in
  let echiquier = from_fen @@ List.nth parts 0 in
  let roque_blanc, roque_noir = roque_of_fen @@ List.nth parts 2 in
  let roi_blanc,roi_noir = trouver_rois echiquier 0 0 (-1, -1) (-1, -1) in
  {
    echiquier;
    trait = if List.nth parts 1 = "w" then Blanc else Noir;
    roi_blanc;
    roi_noir;
    roque_blanc;
    roque_noir;
  }