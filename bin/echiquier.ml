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
  (est_attaque_cav e c pos_roi || (est_attaque_ligne e c pos_roi Fou) 
  || (est_attaque_ligne e c pos_roi Tour) || (est_attaque_pion e c pos_roi))

let est_legal_pion e (c,_) (x,y) (x',y') = 
  if  x <> x' then e.(x').(y') <> Vide else
  (match c with 
   | Blancs -> if y+1 = y' then e.(x').(y') = Vide
      else if y+2 = y' then e.(x').(y+1) = Vide && e.(x').(y') = Vide else false
   | Noirs ->  if y-1 = y' then e.(x').(y') = Vide
    else if y-2 = y' then e.(x').(y-1) = Vide && e.(x').(y') = Vide else false
  )

let pos_suivante e (x,y) (x',y') =
  let copie = Array.map Array.copy e in 
  (copie.(x').(y') <- copie.(x).(y); copie.(x).(y) <- Vide); copie

let est_legal (e : echiquier) (p : piece) pos_dep (x',y') =
  (match p with
  | _,Pion -> est_legal_pion e p pos_dep (x',y')
  | _ -> let f = (get_mouvement p pos_dep ) in 
    List.mem (x',y') f  && (diff_color e x' y' p)) && not (est_echecs (pos_suivante e pos_dep (x',y')) Blancs (4,0) )

(*
 Un coup est légal si :

  OK - Le pion mange ne mange pas comme il se déplace, mais en diagonal
  OK - la piece peut en effet aller sur la case 
  OK la piece saute une piece (si elle est différente du cavalier)
  OK - la case d'arrivée n'est pas occupée par une piece de la même couleur
  OK - il ne faut pas être en échecs après avoir joué le coup, que se soit 
    * car on était en échecs avant et que l'on a joué autre chose 
    * car notre pièce était clouée (i.e. que si on l'enlève cela nous met en situation d'échecs)

  Pour le moment faire un échecs est un coup illégale. 
  Cependant dès que le système de tour est mis en place ce problème sera réglé et très facilement.
*)


let deplacer_piece e (x,y) (x',y') = 
  match e.(x).(y) with 
  | Vide -> raise ILLEGAL_MOOVE
  | Piece p -> if est_legal e p (x,y) (x',y')
    then (e.(x').(y') <-e.(x).(y); e.(x).(y) <- Vide;  true)
    else raise ILLEGAL_MOOVE
      
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
  
  
let afficher_echiquier e = 
  for l = 7 downto 0 do 
    for c = 0 to 7 do 
      match e.(c).(l) with 
      |Vide -> print_string ". "
      |Piece p -> (print_piece p; print_string " ")
    done;
    print_newline ()
  done