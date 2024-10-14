open Test_pieces

exception ILLEGAL_MOOVE

type case = Vide | Piece of piece

type echiquier = case array array

let init_pos x y : case = 

  let col c = function
  | 1 | 8 -> Piece (c,Tour)
  | 2 | 7 -> Piece (c,Cavalier)
  | 3 | 6 -> Piece (c,Fou)
  | 4 -> Piece (c,Dame)
  | 5 -> Piece (c,Roi)
  | _ -> failwith "init"
  in

  if 1<y && y<6 then Vide 
  else if y = 1 then Piece (Blancs, Pion)
  else if y = 6 then Piece (Noirs, Pion)
  else if y = 0 then col Blancs (x+1) 
  else col Noirs (x +1)

let inititialisation () =
  Array.init_matrix 8 8 init_pos

let diff_color e x y (c,_) = 
  match e.(x).(y) with
  | Vide -> true
  | Piece (c',_)-> c' <> c
  
let detection_piece e c (x, y) p' (dx, dy)  =
  let rec aux (x', y') =
    if not (sur_echiquier (x', y')) then false
    else match e.(x').(y') with
      | Piece (c', p) when p = p' || p = Dame -> c <> c'  (* Dame ou pièce spécifiée *)
      | Piece _ -> false
      | Vide -> aux (x' + dx, y' + dy)
  in
    aux (x + dx, y + dy)

let est_attaque_ligne e c (x, y) (p : ptype) =
  let directions = match p with
    | Tour -> [(-1, 0); (1, 0); (0, -1); (0, 1)]  
    | Fou -> [(-1, -1); (-1, 1); (1, -1); (1, 1)]  
    | _ -> [(-1, 0); (1, 0); (0, -1); (0, 1); (-1, -1); (-1, 1); (1, -1); (1, 1)]  
  in
    List.exists (detection_piece e c (x, y) p) directions
    
let est_attaque_pion e c (x,y) =
  let cases = List.filter sur_echiquier (if c = Blancs then [(x-1,y+1);(x+1,y+1)] else [(x-1,y-1);(x+1,y-1)]) in 
  List.exists (fun (x',y') -> match e.(x').(y') with | Piece (c',p) -> p = Pion && c'<> c | _ -> false ) cases

let est_attaque_cav e (c : color) (x,y) = 
  List.exists (fun (x',y') -> match e.(x').(y') with |Vide -> false | Piece (c',_) -> c<>c' ) (get_mouvement (c,Cavalier) (x,y))

let est_echecs e (c: color) pos_roi = 
  est_attaque_cav e c pos_roi
  || est_attaque_ligne e c pos_roi Tour
  || est_attaque_pion e c pos_roi
  || est_attaque_ligne e c pos_roi Fou

let est_legal_pion e (c,_) (x,y) (x',y') = 
  if  x <> x' then e.(x').(y') <> Vide else
  (match c with 
   | Blancs -> if y+1 = y' then e.(x').(y') = Vide
      else if y+2 = y' then e.(x').(y+1) = Vide && e.(x').(y') = Vide else false
   | Noirs ->  if y-1 = y' then e.(x').(y') = Vide
    else if y-2 = y' then e.(x').(y-1) = Vide && e.(x').(y') = Vide else false
  )

let saute_pas_tour e (x, y) (x', y') =
  if x = x' then  (* Mouvement horizontal *)
    let y_min, y_max = min y y', max y y' in
    List.for_all (fun j -> e.(x).(j) = Vide) (List.init (y_max - y_min) (fun i -> y_min + i + 1))
  else if y = y' then  (* Mouvement vertical *)
    let x_min, x_max = min x x', max x x' in
    List.for_all (fun i -> e.(i).(y) = Vide) (List.init (x_max - x_min) (fun i -> x_min + i + 1))
  else false  (* Mouvement invalide pour une tour *)

let saute_pas_fou e (x, y) (x', y') =
  let dir_x = if x' > x then 1 else -1 in
  let dir_y = if y' > y then 1 else -1 in
  List.for_all (fun i -> e.(x + i * dir_x).(y + i * dir_y) = Vide) (List.init (abs (x' - x)) (fun i -> i + 1))
      

let saute_pas e (_,p) (x,y) (x',y') = 
  match p with 
  | Fou -> saute_pas_fou e (x,y) (x',y')
  | Tour -> saute_pas_tour e (x,y) (x',y')
  | Dame -> if x <> x' then (saute_pas_fou e (x,y) (x',y')) else (saute_pas_tour e (x,y) (x',y'))
  | _ -> true 


let est_legal (e : echiquier) (p : piece) pos_dep (x',y') = 
  match p with
  | _,Pion -> est_legal_pion e p pos_dep (x',y')
  | _ -> let f = (get_mouvement p pos_dep ) in 
    List.mem (x',y') f  && (diff_color e x' y' p) && (saute_pas e p pos_dep (x',y') )

let pos_suivante e (x,y) (x',y') =
  let copie = Array.map Array.copy e in 
  (copie.(x').(y') <- copie.(x).(y); copie.(x).(y) <- Vide); copie

let est_legal (e : echiquier) ((c, p') as p : piece) pos_dep (x',y') =
  (match p' with
    | Pion -> est_legal_pion e p pos_dep (x',y')
    | _ -> let f = (get_mouvement p pos_dep ) in List.mem (x',y') f  && (diff_color e x' y' p)) 
  && not (est_echecs (pos_suivante e pos_dep (x',y')) c (4,match c with Blancs -> 0 | Noirs -> 7)) 

let print_piece (c,p) =
  match c, p  with 
  | Noirs , Roi -> print_string "\u{2654}"
  | Noirs , Dame -> print_string "\u{2655}"
  | Noirs , Tour -> print_string "\u{2656}"
  | Noirs , Fou -> print_string "\u{2657}"
  | Noirs , Cavalier -> print_string "\u{2658}"
  | Noirs , Pion -> print_string "\u{2659}"
  | Blancs , Roi -> print_string "\u{265A}"
  | Blancs , Dame -> print_string "\u{265B}"
  | Blancs , Tour -> print_string "\u{265C}"
  | Blancs , Fou -> print_string "\u{265D}"
  | Blancs , Cavalier -> print_string "\u{265E}"
  | Blancs , Pion -> print_string "\u{265F}"

let deplacer_piece e (x,y) (x',y') = 
  match e.(x).(y) with 
  | Vide -> raise ILLEGAL_MOOVE
  | Piece p -> if est_legal e p (x,y) (x',y')
    then (e.(x').(y') <-e.(x).(y); e.(x).(y) <- Vide;  true)
    else raise ILLEGAL_MOOVE
  
  
let afficher_echiquier e = 
  for l = 7 downto 0 do 
    for c = 0 to 7 do 
      match e.(c).(l) with 
      |Vide -> print_string ". "
      |Piece p -> (print_piece p; print_string " ")
    done;
    print_newline ()
  done