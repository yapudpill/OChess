exception Mouvement_invalide

(** Renvoie la liste des coups légaux faisables au départ de la case donnée *)
val coups_legaux : Partie.t -> int * int -> (int * int) list

(** est_legal dep arr indique si le coup allant de dep à arr est légal *)
val est_legal : Partie.t -> int * int -> int * int -> bool

(** deplacer_piece p dep arr déplace la pièce situéee en dep vers arr si le
coup est légal et renvoie le nouvel état de la partie.

Si le dépacement n'est pas légal, lève Mouvement_invalide *)
val jouer : Partie.t -> int * int -> int * int -> Partie.t
