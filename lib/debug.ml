open Printf
let print_pos (x,y)=
  printf "(%d,%d)\n" x y


let rec print_liste_pos = function
  | [] -> print_endline "fin"
  | h::t -> print_pos h; print_liste_pos t


