open List
type color = Blancs | Noirs
type ptype = Pion | Tour | Cavalier | Fou | Dame | Roi

type piece = color * ptype

             
let to_algebrique (x,y) = 
  let cols = [| 'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h' |] in 
  let c = cols.(x-1) in 
  let rangee = string_of_int y in
  String.make 1 c ^ rangee
  
let from_algebrique notation =
  let colonne = notation.[0] in
  let rangee = int_of_string (String.sub notation 1 ((String.length notation) - 1)) in
  let x = (Char.code colonne) - (Char.code 'a') + 1 in
  (x, rangee)

let sur_echiquier (x,y) = 
  0<x && x<9 && 0<y && y<9

  let mouv_fou (x, y) =
      (concat [init 7 (fun i -> (x + i + 1, y + i + 1));
               init 7 (fun i -> (x + i + 1, y - i - 1));
               init 7 (fun i -> (x - i - 1, y + i + 1));
               init 7 (fun i -> (x - i - 1, y - i - 1))])
  

let mouv_tour (x, y) =
    (concat [init 7 (fun i -> (x + i + 1, y));
             init 7 (fun i -> (x - i - 1, y));
             init 7 (fun i -> (x, y + i + 1));
             init 7 (fun i -> (x, y - i - 1))])

  

let mouv_cav (x,y) = 
  [(x+1,y+2);(x-1,y+2); (x-2,y+1); (x-2,y-1); (x-1,y-2); (x+1,y-2); (x+2,y-1); (x+2,y+1) ]

let mouv_dame pos = (mouv_tour pos) @ (mouv_fou pos)

let mouv_roi (x,y) = 
  [(x+1,y+1);(x,y+1); (x-1,y+1); (x-1,y); (x-1,y-1); (x,y-1); (x+1,y-1); (x+1,y) ]

    
let mouv_pion c (x,y) = 
  match c with
  | Blancs -> if y = 1 then [(x,y+1);(x,y+2);(x-1,y+1);(x+1,y+1)] else [(x,y+1);(x-1,y+1);(x+1,y+1)]
  | Noirs  -> if y = 6 then [(x,y-1);(x,y-2);(x-1,y-1);(x+1,y-1)] else [(x,y-1);(x-1,y-1);(x+1,y-1)]
  

let get_mouvement (c,t) =
  Fun.compose (filter sur_echiquier) @@
  match  t with 
  | Roi -> mouv_roi
  | Cavalier -> mouv_cav
  | Tour -> mouv_tour
  | Fou -> mouv_fou
  | Dame -> mouv_dame
  | Pion -> mouv_pion c

(* let test_piece piece pos = 
  map to_algebrique @@ 
  (match piece with 
   | "roi" -> mouv_roi
   | "cav" -> mouv_cav
   | _ -> mouv_roi) pos

let test_piece piece pos=
  map to_algebrique @@ 
  (match piece with 
   | "roi" -> mouv_roi
   | "cav" -> mouv_cav
   | "tour" -> mouv_tour
   | "fou" -> mouv_fou
   | "dame" -> mouv_dame
   | _ -> mouv_roi) (from_algebrique pos) *)