open EntreeSortie
open EntreeSortie.Affichage
open Jeu.Partie

(*** Parsing de la ligne de commande ***)
let couleur, fen =
  let couleur = ref true in
  let fen = ref None in
  let args = [ "--no-colors", Arg.Clear couleur, "Désactive la coloration" ] in
  let doc = "ochess [--no-colors] [\"FEN\"]" in
  let anon s =
    if !fen = None then fen := Some s
    else raise (Arg.Bad "Trop d'arguments")
  in
  Arg.parse args anon doc;
  !couleur, !fen

(*** Sélection des règles et joueurs ***)
let regles : (string * (module Regles.Sig)) list = [
  "Règles basiques", (module Regles.Basique);
  "Roi de la colline", (module Regles.RoiDeLaColine);
  "3 échecs", (module Regles.TroisEchecs);
  "Crazyhouse", (module Regles.Crazyhouse);
]

let joueurs : (string * (module Joueurs.MakeSig)) list = [
  "Vrai joueur", (module Joueurs.Humain.Make)
]

module R  = (val Choix.choix "Veuillez sélectionner les règles :" regles)
module J1 = (val Choix.choix "Veuillez sélectionner le joueur 1 :" joueurs) (R)
module J2 = (val Choix.choix "Veuillez sélectionner le joueur 2 :" joueurs) (R)

(*** Main ***)
let print_etat ((partie, _) as etat) =
  print_echiquier ~couleur partie.echiquier;
  Printf.printf "Trait : %s%s\n"
    (string_of_couleur partie.trait)
    (if R.echec partie then ", échec" else "");
  Option.iter (Printf.printf "Infos : %s\n") (R.string_of_infos etat)

let rec boucle_principale etat =
  (* Nettoie le terminal *)
  print_string "\027[H\027[3J\027[J";

  (* Affiche la partie pour le joueur blanc *)
  print_etat etat;

  let coup = J1.obtenir_coup etat in
  let (partie, _) as etat = R.jouer etat coup in

  if R.egalite etat then (partie, None)
  else if R.perdu etat then (partie, Some Jeu.Piece.Blanc)
  else (
    (* Affiche la partie pour le joueur noir *)
    print_etat etat;

    let coup = J2.obtenir_coup etat in
    let (partie, _) as etat = R.jouer etat coup in

    if R.egalite etat then (partie, None)
    else if R.perdu etat then (partie, Some Jeu.Piece.Noir)
    else (
      print_newline ();
      print_echiquier ~couleur partie.echiquier;
      Printf.printf "(Appuyer sur entrée pour passer au tour suivant)";
      ignore (read_line ());

      boucle_principale etat))

let partie, gagnant =
  let etat = match fen with
  | None -> R.init_partie ()
  | Some fen -> R.init_pos fen
  in
  boucle_principale etat

let () =
  print_newline ();
  print_echiquier ~couleur partie.echiquier;
  print_endline (
    match gagnant with
    | None -> "Pat"
    | Some couleur -> "Vainqueur: " ^ string_of_couleur couleur
  )
