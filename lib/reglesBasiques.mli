exception Mouvement_invalide
val attaquee_dir : Echiquier.t -> Piece.couleur -> int * int -> (int * int) list list
val est_attaquee : Echiquier.t -> Piece.couleur -> int * int -> bool
val coups_legaux : Partie.t -> int * int -> (int * int) list
val est_legal : Partie.t -> int * int -> int * int -> bool
val peut_roquer : Partie.t -> int -> bool
val roque : Partie.t -> int -> Partie.t
val case_depart : Partie.t -> Piece.ptype -> int * int -> (int * int) list
val jouer : Partie.t -> int * int -> int * int -> Partie.t option
val pat : Partie.t -> bool
val mat : Partie.t -> bool
val terminee : Partie.t -> bool
