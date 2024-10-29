open EntreeSortie.Affichage

module R = Regles.Basique

module J1 = Joueurs.Humain.Make(R)
module J2 = Joueurs.Humain.Make(R)

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