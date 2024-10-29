open EntreeSortie
open EntreeSortie.Affichage

let regles : (string * (module Regles.Sig)) list = [
  "Règles basiques", (module Regles.Basique)
]

let joueurs : (string * (module Joueurs.Sig)) list = [
  "Vrai joueur", (module Joueurs.Humain)
]

module R = (val Choix.choix "Veuillez sélectionner les règles :" regles)

module MakeJoueur1 = (val Choix.choix "Veuillez sélectionner le joueur 1 :" joueurs)
module J1 = MakeJoueur1.Make(R)

module MakeJoueur2 = (val Choix.choix "Veuillez sélectionner le joueur 2 :" joueurs)
module J2 = MakeJoueur2.Make(R)

let rec boucle_principale (partie : Jeu.Partie.t) =
  print_string "\027[H\027[J"; (* Nettoie le terminal *)

  print_echiquier ~couleur:false partie.echiquier;
  Printf.printf "Trait : %s\n" (string_of_couleur partie.trait);
  let coup = J1.obtenir_coup partie in
  let partie = R.jouer partie coup in

  if R.pat partie then (partie, None)
  else if R.mat partie then (partie, Some Jeu.Piece.Blanc)
  else begin
    print_newline ();
    print_echiquier ~couleur:false partie.echiquier;
    Printf.printf "Trait : %s\n" (string_of_couleur partie.trait);
    let coup = J2.obtenir_coup partie in
    let partie = R.jouer partie coup in

    if R.pat partie then (partie, None)
    else if R.mat partie then (partie, Some Jeu.Piece.Noir)
    else begin
      print_newline ();
      print_echiquier ~couleur:false partie.echiquier;
      Printf.printf "(Appuyer sur entrée pour passer au tour suivant)";
      ignore (read_line ());

      boucle_principale partie
    end
  end


(* Main *)
let (partie, gagnant) = boucle_principale (R.init_partie ())

let () =
  print_newline ();
  print_echiquier ~couleur:false partie.echiquier;
  print_endline @@ match gagnant with
  | None -> "Pat"
  | Some couleur -> "Vainqueur: " ^ (string_of_couleur couleur)