type t =
| Petit_Roque
| Grand_Roque
| Arrivee of Jeu.Piece.ptype * (int * int)
| Placement of Jeu.Piece.ptype * (int * int)

let to_string = function
| Petit_Roque -> "O-O"
| Grand_Roque -> "O-O-O"
| Placement (p, (x, y)) -> Printf.sprintf "@%c%c%c" (Affichage.char_of_piece p) (char_of_int (97 + x)) (char_of_int (49 + y))
| Arrivee (p, (x, y)) -> Printf.sprintf "%c%c%c" (Affichage.char_of_piece p) (char_of_int (97 + x)) (char_of_int (49 + y))

let from_string str =
  if String.length str > 0 &&  str.[0] = '@' then
    let p = if String.length str = 3 then Some Jeu.Piece.Pion else Affichage.piece_of_char str.[1] in
    let offset = if String.length str = 3 then 1 else 2 in
    let x = int_of_char str.[offset] - 97 in
    let y = int_of_char str.[offset + 1] - 49 in
    Option.map (fun p -> Placement (p, (x, y))) p
  else
    match str with
    | "o-o" | "O-O" -> Some Petit_Roque
    | "o-o-o" | "O-O-O" -> Some Grand_Roque
    | _ ->
      let len = String.length str in
      if len <> 2 && len <> 3 then None
      else
        let p = if len = 2 then Some Jeu.Piece.Pion else Affichage.piece_of_char str.[0] in
        let x = int_of_char str.[len - 2] - 97 in
        let y = int_of_char str.[len - 1] - 49 in
        if Option.is_some p && 0 <= x && x <= 7 && 0 <= y && y <= 7 then Some (Arrivee (Option.get p, (x, y)))
        else None