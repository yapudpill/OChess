(* Types de base *)

type couleur = Blanc | Noir
type ptype = Roi | Dame | Fou | Tour | Cavalier | Pion
type t = couleur * ptype

let inverse = function
| Blanc -> Noir
| Noir -> Blanc


(* Mouvements par défauts *)

let sur_echiquier (x, y) = 0 <= x && x < 8 && 0 <= y && y < 8

let singleton x = [x]

(* Roi *)
let mouv_roi (x, y) = List.filter sur_echiquier [
  (x-1, y+1); (x, y+1); (x+1, y+1);
  (x-1, y  );           (x+1, y  );
  (x-1, y-1); (x, y-1); (x+1, y-1);
]

let mouv_roi_dir pos = List.map singleton (mouv_roi pos)

(* Cavalier *)
let mouv_cav (x,y) = List.filter sur_echiquier [
      (x-1, y+2);   (x+1, y+2);
  (x-2, y+1);          (x+2, y+1);

  (x-2, y-1);          (x+2, y-1);
      (x-1, y-2);   (x+1, y-2);
]

let mouv_cav_dir pos = List.map singleton (mouv_cav pos)

(* Pion *)
let mouv_pion_dir c (x, y) =
  let devant, diagonale = match c with
  | Blanc ->
    (if y = 1 then [ (x, y+1); (x, y+2) ] else [ (x, y+1) ]),
    [ (x-1, y+1); (x+1, y+1) ]
  | Noir  ->
    (if y = 6 then [ (x, y-1); (x, y-2) ] else [ (x, y-1) ]),
    [ (x-1, y-1); (x+1, y-1) ]
  in
  devant :: List.map singleton diagonale

let mouv_pion c pos = List.concat (mouv_pion_dir c pos)

(* Fou *)
let mouv_fou_dir (x, y) =
  let open List in
  [
    init (min (7-x) (7-y)) (fun i -> (x + (i+1), y + (i+1))); (* haut droite *)
    init (min    x  (7-y)) (fun i -> (x - (i+1), y + (i+1))); (* haut gauche *)
    init (min (7-x)    y ) (fun i -> (x + (i+1), y - (i+1))); (* bas  droite *)
    init (min    x     y ) (fun i -> (x - (i+1), y - (i+1))); (* bas  gauche *)
  ]

let mouv_fou pos = List.concat (mouv_fou_dir pos)

(* Tour *)
let mouv_tour_dir (x, y) =
  let open List in
  [
    init (7-y) (fun i -> (x, y + (i+1))); (* haut *)
    init    y  (fun i -> (x, y - (i+1))); (* bas *)
    init (7-x) (fun i -> (x + (i+1), y)); (* droite *)
    init    x  (fun i -> (x - (i+1), y)); (* gauche *)
  ]

let mouv_tour pos = List.concat (mouv_tour_dir pos)

(* Dame *)
let mouv_dame_dir pos = mouv_tour_dir pos @ mouv_fou_dir pos
let mouv_dame pos = mouv_tour pos @ mouv_fou pos

(* Fonctions génériques *)
let mouvement_dir (c, t) =
  match t with
  | Roi -> mouv_roi_dir
  | Dame -> mouv_dame_dir
  | Fou -> mouv_fou_dir
  | Tour -> mouv_tour_dir
  | Cavalier -> mouv_cav_dir
  | Pion -> mouv_pion_dir c

let mouvement (c, t) =
  match t with
  | Roi -> mouv_roi
  | Dame -> mouv_dame
  | Fou -> mouv_fou
  | Tour -> mouv_tour
  | Cavalier -> mouv_cav
  | Pion -> mouv_pion c