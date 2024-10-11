open Echiquier

let e = inititialisation ()

let () = afficher_echiquier  e

let _ = deplacer_piece e (1,1) (5,1)


let () = print_newline ()
let () = print_newline ()

let () = afficher_echiquier  e