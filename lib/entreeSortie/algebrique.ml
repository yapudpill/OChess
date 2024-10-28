open Jeu.Echiquier

let to_algebrique = function
| Petit_roque -> "O-O"
| Grand_roque -> "O-O-O"
| Mouvement (p, (x, y)) ->
  let buf = Buffer.create 3 in
  Buffer.add_char buf (Affichage.char_of_piece p);
  Buffer.add_int8 buf (97 + x);  (* 97 est le code ascii de 'a' *)
  Buffer.add_int8 buf (49 + y);  (* 49 est le code ascii de '1' *)
  Buffer.contents buf

let from_algebrique str = match str with
| "o-o" | "O-O" -> Some Petit_roque
| "o-o-o" | "O-O-O" -> Some Grand_roque
| _ ->
  let len = String.length str in
  if len <> 2 && len <> 3 then None
  else
    let p =
      if len = 2 then Some Jeu.Piece.Pion
      else Affichage.piece_of_char (Char.uppercase_ascii str.[0]) in
    match p with
    | None -> None
    | Some p ->
      let str = String.sub str (len - 2) 2 in
      let x = int_of_char (Char.lowercase_ascii str.[0]) - 97 in (* 97 est le code ascii de 'a' *)
      let y = int_of_char str.[1] - 49 in   (* 49 est le code ascii de '1' *)
      if not (0 <= x && x <= 7 && 0 <= y && y <= 7) then None
      else Some (Mouvement (p, (x, y)))