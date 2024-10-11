
open Test_pieces

exception ILLEGAL_MOOVE

type case = Vide | Piece of piece

type echiquier = case array array


let init_pos y x : case = 
  let col c = function
  | 1 | 8 -> Piece {c; p = Tour}
  | 2 | 7 -> Piece {c; p = Cavalier}
  | 3 | 6 -> Piece {c; p = Fou}
  | 4 -> Piece {c; p = Dame}
  | 5 -> Piece {c; p = Roi}
  | _ -> failwith "init"
  in

  if 1<y && y<6 then Vide 
  else if y = 1 then Piece {c = Blancs; p = Pion}
  else if y = 6 then Piece {c = Noirs; p = Pion}
  else if y = 0 then col Blancs (x+1) 
  else col Noirs (x +1)

let inititialisation () =
  Array.init_matrix 8 8 init_pos

let diff_color e x y p = 
  match e.(x).(y) with
  | Vide -> true
  | Piece {c;_}-> p.c <> c

let deplacer_piece e (x,y) (x',y') = 
  match e.(x).(y) with 
  | Vide -> raise ILLEGAL_MOOVE
  | Piece p -> let f = (get_mouvement p (x,y) ) in 
    if List.mem (x',y') f  && (diff_color e x' y' p) 
      then (e.(x').(y') <-e.(x).(y); e.(x).(y) <- Vide;  true)
      else raise ILLEGAL_MOOVE

let print_piece {c;p} =
  match c, p  with 
  | Blancs , Roi -> print_string "\u{2654}"
  | Blancs , Dame -> print_string "\u{2655}"
  | Blancs , Tour -> print_string "\u{2656}"
  | Blancs , Fou -> print_string "\u{2657}"
  | Blancs , Cavalier -> print_string "\u{2658}"
  | Blancs , Pion -> print_string "\u{2659}"
  | Noirs , Roi -> print_string "\u{265A}"
  | Noirs , Dame -> print_string "\u{265B}"
  | Noirs , Tour -> print_string "\u{265C}"
  | Noirs , Fou -> print_string "\u{265D}"
  | Noirs , Cavalier -> print_string "\u{265E}"
  | Noirs , Pion -> print_string "\u{265F}"

 




(* Afficher l'état de l'échiquier *)
let afficher_echiquier board =
  Array.iter (fun ligne ->
    Array.iter (fun case ->
      match case with
      | Vide -> print_string ". "
      | Piece p -> (print_piece p; print_string " ")
    ) ligne;
    print_newline ()
  ) board


