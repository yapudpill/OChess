open Jeu.Piece
open Jeu.Echiquier
open Jeu.Partie

include ReglesBasiques

type infos = {pieces_blanches : Jeu.Piece.ptype list; pieces_noires : Jeu.Piece.ptype list}


let string_of_infos (partie,infos) =
  let pieces = match partie.trait with
    | Blanc -> infos.pieces_blanches
    | Noir -> infos.pieces_noires
  in
  let piece_strs = List.map (fun p -> String.make 1 (EntreeSortie.Affichage.char_of_piece p)) pieces in
  Some (String.concat ", " piece_strs)

(*** Création d'une partie ***)

let init_pos fen =
  EntreeSortie.Fen.creer_partie_fen fen,{pieces_blanches = []; pieces_noires = []}

let init_partie () = init_pos "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -"

let coup_of_algebrique partie = function
| EntreeSortie.Algebrique.Placement (p,arr) -> Ok (Placement  (p,arr))
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

let peut_poser (partie,infos) p (x, y) =
  (* Vérifie si le joueur possède la pièce à placer *)
  let liste_pieces = match partie.trait with
    | Blanc -> infos.pieces_blanches
    | Noir -> infos.pieces_noires
  in
  if List.mem p liste_pieces then
    (* Simule le placement et vérifie qu'il n'entraîne pas un échec *)
    let echiquier = Array.map Array.copy partie.echiquier in
    echiquier.${x, y} <- Some (partie.trait, p);
    not (est_attaquee { partie with echiquier } partie.trait (get_pos_roi partie partie.trait))
  else
    false

let supprimer x lst =
  let rec aux acc = function
  | [] -> List.rev acc
  | h :: t when h = x -> List.rev_append acc t
  | h :: t -> aux (h :: acc) t
  in
  aux [] lst

let maj_pieces (partie,infos) arr =
  match partie.echiquier.${arr} with
  | None -> infos
  | Some (_,p) -> match partie.trait with
    | Blanc -> {infos with pieces_blanches = infos.pieces_blanches @ [p] }
    | Noir -> {infos with pieces_noires = infos.pieces_noires @ [p]}

let poser_piece (partie,infos) p pos =
  let echiquier = Array.map Array.copy partie.echiquier in
  echiquier.${pos} <- Some (partie.trait,p);
  {partie with echiquier; trait = inverse partie.trait},(match partie.trait with
    | Blanc -> {infos with pieces_blanches = supprimer p infos.pieces_blanches }
    | Noir ->  {infos with pieces_noires = supprimer p infos.pieces_noires }
  )

let jouer (partie,infos) = function
  | Grand_Roque -> roque partie (-1), infos
  | Petit_Roque -> roque partie 1, infos
  | Mouvement (dep, arr) ->
  if est_legal partie dep arr then
    let infos = maj_pieces (partie,infos) arr in
    let partie = deplacer_piece partie dep arr in
    {partie with trait = inverse partie.trait},infos
  else failwith "jouer"
  | Placement (p,arr) ->
  if peut_poser (partie,infos) p arr then
    poser_piece (partie,infos) p arr
  else failwith "jouer"
