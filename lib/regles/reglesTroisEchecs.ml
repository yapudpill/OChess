open Jeu.Piece
open Jeu.Partie

include ReglesBasiques

type infos = { echecs_blanc : int; echecs_noir : int }
let string_of_infos i =
  Some (Printf.sprintf "echecs blanc : %d, echecs noir : %d" i.echecs_blanc i.echecs_noir)


(*** Création d'une partie ***)
let init_pos fen =
  EntreeSortie.Fen.creer_partie_fen fen, { echecs_blanc = 0; echecs_noir = 0 }

let init_partie () = init_pos "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -"


(*** Jouer un coup ***)
let maj_echec infos = function
| Blanc -> { infos with echecs_blanc = infos.echecs_blanc + 1 }
| Noir  -> { infos with echecs_noir  = infos.echecs_noir  + 1 }

let jouer (partie, infos) coup =
  let (partie, ()) = ReglesBasiques.jouer (partie, ()) coup in
  let infos = if echec partie then maj_echec infos partie.trait else infos in
  (partie, infos)


(*** Fin de partie ***)
let trois_echecs infos = function
| Blanc -> infos.echecs_blanc = 3
| Noir  -> infos.echecs_noir  = 3

let perdu (partie, infos) = mat partie || trois_echecs infos partie.trait

let egalite (partie, _) = ReglesBasiques.egalite (partie, ())