open Jeu.Partie
open Jeu.Piece

include ReglesBasiques

let au_centre partie =
  List.mem (get_pos_roi partie (inverse partie.trait) ) [(3,4);(4,4);(4,3);(3,3)]


let perdu (partie,()) =
  mat partie || au_centre partie