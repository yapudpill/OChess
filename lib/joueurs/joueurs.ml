module type MakeSig = functor (_ : Regles.Sig) -> sig
  val obtenir_coup : Jeu.Partie.t -> Jeu.Partie.coup
end

module type Sig = sig
  module Make : MakeSig
end

module Humain : Sig = Humain