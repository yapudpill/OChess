type t =
| Petit_Roque
| Grand_Roque
| Arrivee of Jeu.Piece.ptype * (int * int)

let to_string = function
| Petit_Roque -> "O-O"
| Grand_Roque -> "O-O-O"
| Arrivee (p, (x, y)) ->
  let buf = Buffer.create 3 in
  Buffer.add_char buf (Affichage.char_of_piece p);
  Buffer.add_int8 buf (97 + x);  (* 97 est le code ascii de 'a' *)
  Buffer.add_int8 buf (49 + y);  (* 49 est le code ascii de '1' *)
  Buffer.contents buf

let from_string str = match str with
| "o-o" | "O-O" -> Some Petit_Roque
| "o-o-o" | "O-O-O" -> Some Grand_Roque
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
      else Some (Arrivee (p, (x, y)))