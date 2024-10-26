open Piece
open Echiquier
open Partie

(* Fonction pour convertir un caractère en pièce (ptype, couleur) *)
let piece_of_char c =
  let up = Char.uppercase_ascii c in
  let couleur = if up = c then Blanc else Noir in
  let ptype = match up with
    | 'R' -> Tour
    | 'N' -> Cavalier
    | 'B' -> Fou
    | 'Q' -> Dame
    | 'K' -> Roi
    | 'P' -> Pion
    | _ -> failwith "Caractère non valide"
  in
  Piece (couleur, ptype)

(* Fonction auxiliaire récursive *)
let rec from_fen_aux fen echiquier x y k =
  if k >= String.length fen then echiquier
  else
    match fen.[k] with
    (* Sauter à la rangée suivante *)
    | '/' ->
      from_fen_aux fen echiquier 0 (y - 1) (k + 1)
    (* Sauter des cases vides *)
    | '0' .. '9' as c ->
      let avance = int_of_char c - int_of_char '0' in
      from_fen_aux fen echiquier (x + avance) y (k + 1)
    (* Placer la pièce et passer à la case suivante *)
    | c ->
      echiquier.${x, y} <- piece_of_char c;
      from_fen_aux fen echiquier (x + 1) y (k + 1)

(* Fonction principale from_fen *)
let from_fen fen =
  let echiquier = Array.init_matrix 8 8 (fun _ _ -> Vide) in
  from_fen_aux fen echiquier 0 7 0

let rec trouver_rois echiquier x y roi_blanc roi_noir =
  if x = 8 then (roi_blanc, roi_noir)
  else if y = 8 then trouver_rois echiquier (x + 1) 0 roi_blanc roi_noir
  else match echiquier.${x, y} with
  | Piece (Blanc, Roi) -> trouver_rois echiquier x (y + 1) (x, y) roi_noir
  | Piece (Noir, Roi) -> trouver_rois echiquier x (y + 1) roi_blanc (x, y)
  | _ -> trouver_rois echiquier x (y + 1) roi_blanc roi_noir

(* Fonction pour convertir les droits de roque depuis le FEN *)
let roque_of_fen roque_str =
  let roque_blanc = (String.contains roque_str 'Q', String.contains roque_str 'K') in
  let roque_noir = (String.contains roque_str 'q', String.contains roque_str 'k') in
  (roque_blanc, roque_noir)

(* Fonction principale pour créer une partie à partir d'une FEN *)
let creer_partie_fen fen =
  (* On découpe le FEN en différentes sections *)
  let parts = String.split_on_char ' ' fen in
  let echiquier = from_fen @@ List.nth parts 0 in
  let roque_blanc, roque_noir = roque_of_fen @@ List.nth parts 2 in
  let roi_blanc, roi_noir = trouver_rois echiquier 0 0 (-1, -1) (-1, -1) in
  if roi_blanc = (-1, -1) || roi_noir = (-1, -1) then failwith "FEN invalide"
  else
    {
      echiquier;
      trait = if List.nth parts 1 = "w" then Blanc else Noir;
      roi_blanc;
      roi_noir;
      roque_blanc;
      roque_noir;
    }