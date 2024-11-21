type t =
| Petit_Roque
| Grand_Roque
| Arrivee of Jeu.Piece.ptype * (int * int)
| Placement of Jeu.Piece.ptype * (int * int)
| NonAmbigu of (int * int) * Jeu.Piece.ptype * (int * int)

val to_string : t -> string
(** Convertit un mouvement [t] en une chaîne de caractères.
    @param move Le mouvement à convertir.
    @return Une chaîne décrivant le mouvement selon la notation adaptée. *)

val from_string : string -> t option
(** Convertit une chaîne de caractères en un mouvement [t], si valide.
    @param s La chaîne représentant un mouvement.
    @return [Some t] si la chaîne correspond à un mouvement valide,
            [None] si la chaîne ne correspond à aucun mouvement reconnu. *)