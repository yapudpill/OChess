open Jeu

val attaquee_dir : Partie.t -> Piece.couleur -> int * int -> (int * int) list list
val est_attaquee : Partie.t -> Piece.couleur -> int * int -> bool
val coups_legaux : Partie.t -> int * int -> (int * int) list
val est_legal : Partie.t -> int * int -> int * int -> bool
val peut_roquer : Partie.t -> int -> bool
val coup_of_algebrique : Partie.t -> EntreeSortie.Algebrique.t -> (Partie.coup, Partie.erreur) result
val jouer : Partie.t -> Partie.coup -> Partie.t
val pat : Partie.t -> bool
val mat : Partie.t -> bool
val terminee : Partie.t -> bool
