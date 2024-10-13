open Echiquier

let e = inititialisation ()

let () = afficher_echiquier  e


(* let _ = deplacer_piece e (4,1) (4,3) 
let _ = deplacer_piece e (3,6) (3,4) 

let _ = deplacer_piece e (4,3) (3,4)
let _ = deplacer_piece e (3,7) (3,4) 

let _  = deplacer_piece e (1,0) (2,2)
let _  = deplacer_piece e (3,4) (4,4)  

TEST ECHECS VERTICAL
*)

(* let _ = deplacer_piece e (2,6) (2,4)
let _ = deplacer_piece e (2,4) (2,3)
let _ = deplacer_piece e (2,3) (2,2)
let _ = deplacer_piece e (2,2) (3,1)

TEST ECHECS PION
*)



let _ = deplacer_piece e (5,1) (5,2) 
let _ = deplacer_piece e (4,6) (4,4) 

(* let _ = deplacer_piece e (3,7) (7,3) *)






let () = print_newline ()
let () = print_newline ()

let () = afficher_echiquier  e


(* 
CONVENTION : la case e1 se note (4,0)


*)