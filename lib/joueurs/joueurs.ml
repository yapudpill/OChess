module type MakeSig = functor (R : Regles.Sig) -> sig
  val obtenir_coup : (Jeu.Partie.t * R.infos) -> Jeu.Partie.coup
end

module type Sig = sig
  module Make : MakeSig
end

module Humain : Sig = Humain