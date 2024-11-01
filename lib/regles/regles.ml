module type Sig = sig
  open Jeu

  type infos
  val string_of_infos : Partie.t * infos -> string option

  val init_partie : unit -> Partie.t * infos
  val init_pos : string -> Partie.t * infos

  val attaquee_dir : Partie.t -> Piece.couleur -> int * int -> (int * int) list list
  val est_attaquee : Partie.t -> Piece.couleur -> int * int -> bool

  val coups_legaux : Jeu.Partie.t -> int * int -> (int * int) list
  val est_legal : Jeu.Partie.t -> int * int -> int * int -> bool

  val peut_roquer : Partie.t -> int -> bool

  val coup_of_algebrique : (Partie.t * infos) -> EntreeSortie.Algebrique.t -> (Partie.coup, Partie.erreur) result
  val jouer : Jeu.Partie.t * infos -> Partie.coup -> Jeu.Partie.t * infos

  val perdu : Jeu.Partie.t * infos -> bool
  val egalite : Jeu.Partie.t * infos -> bool

end

module Basique : Sig = ReglesBasiques
module RoiDeLaColine : Sig = ReglesRoiDeLaColine
module TroisEchecs : Sig = ReglesTroisEchecs
module Crazyhouse : Sig = ReglesCrazyhouse