open EntreeSortie
open EntreeSortie.Affichage
open Jeu.Partie

(*** Activation des couleurs ***)
let couleur =
  let tmp = ref true in
  let args = [ ("--no-colors", Arg.Clear tmp, "Désactive la coloration") ] in
  let doc = "ochess [--no-colors]" in
  let anon s = raise (Arg.Bad (Printf.sprintf "Option inconnue : %s" s)) in
  Arg.parse args anon doc;
  !tmp


(*** Sélection des règles et joueurs ***)
let regles : (string * (module Regles.Sig)) list = [
  "Règles basiques", (module Regles.Basique);
  "Roi de la colline", (module Regles.RoiDeLaColine);
  "3 échecs", (module Regles.TroisEchecs);
  "Crazyhouse", (module Regles.Crazyhouse)

]

let joueurs : (string * (module Joueurs.MakeSig)) list = [
  "Vrai joueur", (module Joueurs.Humain.Make)
]

module R  = (val Choix.choix "Veuillez sélectionner les règles :" regles)
module J1 = (val Choix.choix "Veuillez sélectionner le joueur 1 :" joueurs) (R)
module J2 = (val Choix.choix "Veuillez sélectionner le joueur 2 :" joueurs) (R)


(*** Main ***)
let rec boucle_principale (partie, infos) =
  print_string "\027[H\027[J"; (* Nettoie le terminal *)

  print_echiquier ~couleur partie.echiquier;
  Printf.printf "Trait : %s\n" (string_of_couleur partie.trait);
  Option.fold (R.string_of_infos (partie,infos) ) ~none:() ~some:(Printf.printf "Infos : %s\n");

  let coup = J1.obtenir_coup (partie, infos) in
  let partie,infos = R.jouer (partie,infos) coup in

  if R.egalite (partie, infos) then (partie, None)
  else if R.perdu (partie,infos) then (partie, Some Jeu.Piece.Blanc)
  else begin
    print_newline ();
    print_echiquier ~couleur partie.echiquier;
    Printf.printf "Trait : %s\n" (string_of_couleur partie.trait);
    Option.iter (Printf.printf "Infos : %s\n") (R.string_of_infos (partie,infos));

    let coup = J2.obtenir_coup (partie, infos) in
    let partie,infos = R.jouer (partie,infos) coup in

    if R.egalite (partie, infos) then (partie, None)
    else if R.perdu (partie, infos) then (partie, Some Jeu.Piece.Noir)
    else begin
      print_newline ();
      print_echiquier ~couleur partie.echiquier;
      Printf.printf "(Appuyer sur entrée pour passer au tour suivant)";
      ignore (read_line ());

      boucle_principale (partie,infos)
    end
  end

let (partie, gagnant) = boucle_principale (R.init_partie ())

let () =
  print_newline ();
  print_echiquier ~couleur partie.echiquier;
  print_endline @@ match gagnant with
  | None -> "Pat"
  | Some couleur -> "Vainqueur: " ^ (string_of_couleur couleur)