open Jeu.Piece
open Jeu.Echiquier

let string_of_couleur = function
| Blanc -> "Blanc"
| Noir -> "Noir"

let char_of_piece = function
| Roi -> 'R'
| Dame -> 'D'
| Fou -> 'F'
| Tour -> 'T'
| Cavalier -> 'C'
| Pion -> 'P'

let piece_of_char = function
| 'R' -> Some Roi
| 'D' -> Some Dame
| 'F' -> Some Fou
| 'T' -> Some Tour
| 'C' -> Some Cavalier
| 'P' -> Some Pion
| _ -> None

let unicode_of_piece ?(couleur = true) (c, p) =
  Uchar.of_int @@
    9812 (* Caractère vide unicode de base *)
    + (if couleur || c = Blanc then 6 else 0) (* Utiliser les caractères pleins *)
    + match p with (* Sélectionner le caractères correspondant au type *)
      | Roi -> 0
      | Dame -> 1
      | Tour -> 2
      | Fou -> 3
      | Cavalier -> 4
      | Pion -> 5

let string_of_echiquier ?(couleur = true) e =
             (* [| bleu foncé; bleu clair  |] *)
  let bg_cols = [| "\027[44m"; "\027[106m" |] in
  let fg_col = function Blanc -> "\027[97m" | Noir -> "\027[30m" in
  let fin_col = "\027[0m" in

  let buf = Buffer.create 256 in
  for l = 7 downto 0 do
    Buffer.add_string buf (string_of_int (l + 1) ^ " ");

    for c = 0 to 7 do
      if couleur then Buffer.add_string buf bg_cols.((l + c) mod 2);

      match e.${c, l} with
      | None -> Buffer.add_string buf (if couleur then "   " else " . ")
      | Some (c, p) ->
          Buffer.add_char buf ' ';
          if couleur then Buffer.add_string buf (fg_col c);
          Buffer.add_utf_8_uchar buf (unicode_of_piece ~couleur (c, p));
          Buffer.add_char buf ' '
    done;

    if couleur then Buffer.add_string buf fin_col;
    Buffer.add_char buf '\n'
  done;
  Buffer.add_string buf "   A  B  C  D  E  F  G  H \n";
  Buffer.contents buf

let print_echiquier ?(couleur = true) e =
  print_string (string_of_echiquier ~couleur e)
