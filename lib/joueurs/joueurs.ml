module type Sig = sig

  module Make : functor (_ : Regles.Sig) -> sig
    val obtenir_coup : Jeu.Partie.t -> Jeu.Partie.coup
  end

end

module Humain : Sig = Humain