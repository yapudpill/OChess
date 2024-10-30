open Printf
open Jeu.Partie
open Jeu.Piece
open EntreeSortie.Affichage

let print_pos (x,y)=
  printf "(%d,%d)\n" x y

let print_couleur = function
   | Blanc -> print_endline "Blanc"
   | Noir -> print_endline "Noir"

let string_pos_alg (x,y) =
  let buf = Buffer.create 2 in
  Buffer.add_int8 buf (97 + x);  (* 97 est le code ascii de 'a' *)
  Buffer.add_int8 buf (49 + y);  (* 49 est le code ascii de '1' *)
  Buffer.contents buf

let print_bool = function
  | true -> print_endline "true"
  | _ -> print_endline "false"

let rec print_liste_pos = function
  | [] -> print_endline "fin"
  | h::t -> print_pos h; print_liste_pos t

let print_prise_en_passant m =
  print_string "prise en passant : ";
  let n = Option.value m ~default:(-1,-1) in
  if  n = (-1,-1) then print_endline "-"
  else print_endline @@ string_pos_alg n

let print_partie partie =
  print_echiquier ~couleur:false partie.echiquier;
  print_endline @@ "trait : " ^ (string_of_couleur partie.trait);
  print_string "Roi blanc : "; print_pos partie.roi_blanc;
  print_string "Roi noir : "; print_pos partie.roi_noir;
  print_prise_en_passant partie.en_passant


let print_partie' partie =
    EntreeSortie.Affichage.print_echiquier ~couleur:false partie.echiquier;
    print_endline @@ "trait : " ^ (string_of_couleur partie.trait);
    print_endline @@ "Roi blanc : " ^ (string_pos_alg partie.roi_blanc);
    print_endline @@ "Roi noir : " ^ (string_pos_alg partie.roi_noir);
    print_prise_en_passant partie.en_passant;
    print_endline "Votre coup : "

