(** Types de base pour la représentation d'un échiquier. *)

type case = Piece.t option
(** Représente une case sur l'échiquier.
    Une case peut contenir une pièce ([Some p]) ou être vide ([None]). *)

type t = case array array
(** Représente l'échiquier comme une grille bidimensionnelle, où chaque case est accessible
    via un tableau à deux dimensions. *)

(* Accès/modificaton d'échiquier *)
val ( .${} ) : t -> int * int -> case
(** Accède à une case spécifique de l'échiquier.

    @param echiquier L'échiquier dont on veut connaître les infos.
    @param (x, y) Les coordonnées de la case, où [x] est l'indice de la ligne
                  et [y] l'indice de la colonne.
    @return La case correspondante, qui peut être vide ([None]) ou contenir une pièce ([Some p]). *)

val ( .${}<- ) : t -> int * int -> case -> unit
(** Modifie une case spécifique de l'échiquier.

    @param echiquier L'échiquier à modifier.
    @param (x, y) Les coordonnées de la case à mettre à jour.
    @param c La nouvelle valeur pour la case, qui peut être vide ([None]) ou contenir une pièce ([Some p]). *)

val est_adversaire : Piece.couleur -> case -> bool
(** Vérifie si une case contient une pièce d'un adversaire donné.

    @param c La couleur du joueur en cours.
    @param case La case à examiner.
    @return [true] si la case contient une pièce d'une couleur opposée, [false] sinon. *)

val est_vide_ou_adversaire : Piece.couleur -> case -> bool
(** Vérifie si une case est vide ou contient une pièce adverse.

    @param c La couleur du joueur en cours.
    @param case La case à examiner.
    @return [true] si la case est vide ou contient une pièce d'une couleur opposée, [false] sinon. *)

val contient : t -> Piece.t -> int * int -> bool
(** Vérifie si une case contient une pièce donnée.

    @param p La pièce recherchée.
    @param case La case à examiner.
    @return [true] si la case contient exactement la pièce donnée, [false] sinon. *)

val est_vide : case -> bool
(** Vérifie si une case est vide.

    @param case La case à examiner.
    @return [true] si la case est vide ([None]), [false] sinon. *)
