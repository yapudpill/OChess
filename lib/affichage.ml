open Piece
open Echiquier

let char_of_piece = function
  | Roi -> 'R'
  | Dame -> 'D'
  | Fou -> 'F'
  | Tour -> 'T'
  | Cavalier -> 'C'
  | Pion -> 'P'

let piece_of_char = function
  | 'R' -> Roi
  | 'D' -> Dame
  | 'F' -> Fou
  | 'T' -> Tour
  | 'C' -> Cavalier
  | 'P' -> Pion
  | _ -> invalid_arg "piece_of_char"

let to_algebrique p (x,y) =
  let buf = Buffer.create 3 in
  Buffer.add_char buf (char_of_piece p);
  Buffer.add_char buf (char_of_int (97 + x));  (* 97 est le code ascii de 'a' *)
  Buffer.add_int8 buf (y+1);
  Buffer.contents buf

let from_algebrique str =
  let len = String.length str in
  if len <> 2 && len <> 3 then invalid_arg "from_algebrique"
  else
    let p = if len = 2 then Pion else piece_of_char (Char.uppercase_ascii str.[0]) in
    let str = String.sub str (len - 2) 2 in
    let x = int_of_char (Char.lowercase_ascii str.[0]) - 97 in (* 97 est le code ascii de 'a' *)
    let y = int_of_char str.[1] - 49 in   (* 49 est le code ascii de '1' *)
    assert (0 <= x && x <= 7 && 0 <= y && y <= 7);
    p, (x, y)


let unicode_of_piece ?(couleur = true) (c, p) =
  Uchar.of_int @@
  9812   (* Caractère vide unicode de base *)
  + (if couleur || c = Blanc then 6 else 0)  (* Utiliser les caractères pleins *)
  + match p with  (* Sélectionner le caractères correspondant au type *)
    | Roi -> 0
    | Dame -> 1
    | Tour -> 2
    | Fou -> 3
    | Cavalier -> 4
    | Pion -> 5


let string_of_echiquier ?(couleur = true) e =
  let bg_cols = [| "\027[44m"; "\027[106m" |] in (* [| bleu foncé; bleu clair |]*)
  let fg_col c = match c with Blanc -> "\027[97m" | Noir -> "\027[30m" in
  let fin_col ="\027[0m" in

  let buf = Buffer.create 256 in
  for l = 7 downto 0 do
    for c = 0 to 7 do
      if couleur then Buffer.add_string buf bg_cols.((l + c) mod 2);

      begin match e.${c, l} with
      | Vide -> Buffer.add_string buf (if couleur then "   " else " . ")
      | Piece (c, p) ->
        Buffer.add_char buf ' ';
        if couleur then Buffer.add_string buf (fg_col c);
        Buffer.add_utf_8_uchar buf (unicode_of_piece ~couleur (c, p));
        Buffer.add_char buf ' ';
      end;

      if couleur then Buffer.add_string buf fin_col;
    done;
    Buffer.add_char buf '\n'
  done;
  Buffer.contents buf