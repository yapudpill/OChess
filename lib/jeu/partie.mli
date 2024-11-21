type t = {
  echiquier : Echiquier.t;
  trait : Piece.couleur;
  roi_blanc : int * int;
  roi_noir : int * int;
  roque_blanc : bool * bool;
  roque_noir : bool * bool;
  en_passant : (int * int) option;
}

type erreur = Invalide | Ambigu of (int * int) list

type coup =
| Petit_Roque
| Grand_Roque
| Placement of Piece.ptype * (int * int)
| Mouvement of (int * int) * (int * int)

val get_pos_roi : t -> Piece.couleur -> int * int
(** Renvoie la position actuelle du roi pour une couleur donnée.

    @param partie La partie à interroger.
    @param couleur La couleur du roi ([Piece.Blanc] ou [Piece.Noir]).
    @return Un couple [(x, y)] représentant la position du roi sur l'échiquier. *)

val get_roque : t -> Piece.couleur -> bool * bool
(** Renvoie les droits de roque pour une couleur donnée.

    @param partie La partie à interroger.
    @param couleur La couleur du joueur ([Piece.Blanc] ou [Piece.Noir]).
    @return Un couple [(petit_roque, grand_roque)] représentant les droits de roque du joueur. *)

val set_pos_roi : Piece.couleur -> int * int -> t -> t
(** Met à jour la position du roi pour une couleur donnée.

    @param couleur La couleur du roi ([Piece.Blanc] ou [Piece.Noir]).
    @param position La nouvelle position du roi, sous forme de couple [(x, y)].
    @param partie La partie à modifier.
    @return Une nouvelle instance de la partie avec la position du roi mise à jour.
            Les droits de roque associés sont automatiquement désactivés. *)

val set_roque : Piece.couleur -> bool * bool -> t -> t
(** Met à jour les droits de roque pour une couleur donnée.

    @param couleur La couleur du joueur ([Piece.Blanc] ou [Piece.Noir]).
    @param roque Un couple [(petit_roque, grand_roque)] représentant les nouveaux droits de roque.
    @param partie La partie à modifier.
    @return Une nouvelle instance de la partie avec les droits de roque mis à jour. *)

val peut_roquer_sans_echec : t -> int -> bool
(** Vérifie si un roque est réalisable sans passer par une position attaquée.

    @param partie La partie à analyser.
    @param type_roque Le type de roque :
                      - [1] pour le petit roque,
                      - [0] pour le grand roque.
    @return [true] si le roque est possible sans échec, [false] sinon. *)