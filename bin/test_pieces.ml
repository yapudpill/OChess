open List
type color = Blancs | Noirs
type 'a couple = {x : 'a; y : 'a}

type piece = {c : color; mouv : int couple -> int couple list}

             
let to_algebrique pos = 
  let x,y = pos in 
  let cols = [| 'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h' |] in 
  let c = cols.(x-1) in 
  let rangee = string_of_int y in
  String.make 1 c ^ rangee
  
let from_algebrique notation =
  let colonne = notation.[0] in
  let rangee = int_of_string (String.sub notation 1 ((String.length notation) - 1)) in
  let x = (Char.code colonne) - (Char.code 'a') + 1 in
  (x, rangee)

let sur_echiquier pos = let x,y = pos in 
  0<x && x<9 && 0<y && y<9

  let mouv_fou (x, y) =
    filter sur_echiquier
      (concat [init 7 (fun i -> (x + i + 1, y + i + 1));
               init 7 (fun i -> (x + i + 1, y - i - 1));
               init 7 (fun i -> (x - i - 1, y + i + 1));
               init 7 (fun i -> (x - i - 1, y - i - 1))])
  

let mouv_tour (x, y) =
  filter sur_echiquier
    (concat [init 7 (fun i -> (x + i + 1, y));
             init 7 (fun i -> (x - i - 1, y));
             init 7 (fun i -> (x, y + i + 1));
             init 7 (fun i -> (x, y - i - 1))])

  

let mouv_cav (x,y) = 
  filter sur_echiquier [(x+1,y+2);(x-1,y+2); (x-2,y+1); (x-2,y-1); (x-1,y-2); (x+1,y-2); (x+2,y-1); (x+2,y+1) ]

let mouv_dame pos = (mouv_tour pos) @ (mouv_fou pos)

let mouv_roi (x,y) = 
  filter sur_echiquier [(x+1,y+1);(x,y+1); (x-1,y+1); (x-1,y); (x-1,y-1); (x,y-1); (x+1,y-1); (x+1,y) ]

    
let test_piece piece pos = 
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
   | _ -> mouv_roi) (from_algebrique pos)