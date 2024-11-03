(* Types de base *)
type couleur = Blanc | Noir
type ptype = Roi | Dame | Fou | Tour | Cavalier | Pion
type t = couleur * ptype

val inverse : couleur -> couleur
(** Inverse la couleur passée en entrée *)

(* Mouvement non dirigé :
   Les fonctions de la forme mouv_<piece> renvoient la liste des cases atteignables
   en un déplacement à partir de la case de départ donnée. *)
val mouv_roi : int * int -> (int * int) list
val mouv_cav : int * int -> (int * int) list
val mouv_pion : couleur -> int * int -> (int * int) list
val mouv_fou : int * int -> (int * int) list
val mouv_tour : int * int -> (int * int) list
val mouv_dame : int * int -> (int * int) list
val mouvement : t -> int * int -> (int * int) list

(* Mouvement dirigé :
   Les fonctions de la forme mouv_<piece>_dir renvoient la liste des cases
   atteignables en un déplacements à partir de la case de départ donnée, classées
   selon leur direction.
   Chaque direction est classée par ordre d'éloignement à la pièce. *)
val mouv_roi_dir : int * int -> (int * int) list list
val mouv_cav_dir : int * int -> (int * int) list list
val mouv_pion_dir : couleur -> int * int -> (int * int) list list
val mouv_fou_dir : int * int -> (int * int) list list
val mouv_tour_dir : int * int -> (int * int) list list
val mouv_dame_dir : int * int -> (int * int) list list
val mouvement_dir : t -> int * int -> (int * int) list list
