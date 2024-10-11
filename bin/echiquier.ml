
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

  
let deplacer_piece e (x,y) (x',y') = 
  match e.(x).(y) with 
  | Vide -> raise ILLEGAL_MOOVE
  | Piece p -> let f = (get_mouvement p (x,y) ) in 
    if List.mem (x',y') f  && (diff_color e x' y' p)
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



