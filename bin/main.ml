open Echiquier

let e = inititialisation ()

let () = afficher_echiquier  e

let _ = deplacer_piece e (4,1) (4,3)
(* let _ = deplacer_piece e (4,1) (4,3) *)


let () = print_newline ()
let () = print_newline ()

let () = afficher_echiquier  e


(* 
CONVENTION : la case e1 se note (4,0)


*)