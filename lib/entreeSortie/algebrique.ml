type t =
| Petit_Roque
| Grand_Roque
| Arrivee of Jeu.Piece.ptype * (int * int)
| Placement of Jeu.Piece.ptype * (int * int)
| NonAmbigu of (int * int) * Jeu.Piece.ptype * (int * int)

let to_string =
  let aux p (x, y) =
    Printf.sprintf "%c%c%d"
      (Affichage.char_of_piece p)
      (char_of_int (97 + x)) (* 97 est le code ascii de 'a' *)
      (y + 1)
  in
  function
  | Petit_Roque -> "O-O"
  | Grand_Roque -> "O-O-O"
  | Placement (p, pos) -> "@" ^ aux p pos
  | Arrivee (p, pos) -> aux p pos
  | NonAmbigu ((x, y), p, arr) ->
      let coup_normal = aux p arr in
      (* 97 est le code ascii de 'a' et 49 celui de '1' *)
      let insert = char_of_int (if x <> -1 then 97 + x else 49 + y) in
      String.init 4 (function 0 -> coup_normal.[0] | 1 -> insert | n -> coup_normal.[n+1])


let from_string = function
| "o-o" | "O-O" -> Some Petit_Roque
| "o-o-o" | "O-O-O" -> Some Grand_Roque
| str ->
    let len = String.length str in
    if len < 2 || len > 4 then None
    else
      let placement = str.[0] = '@' in
      let non_ambigu = len = 4 && not placement in
      let x = int_of_char (Char.lowercase_ascii str.[len - 2]) - 97 in
      let y = int_of_char str.[len - 1] - 49 in
      let p =
        if len = 2 || (len = 3 && placement) then Some Jeu.Piece.Pion
        else Affichage.piece_of_char (Char.uppercase_ascii str.[if placement then 1 else 0])
      in
      let ambigu_info =
        match Char.lowercase_ascii str.[1] with
        | 'a' .. 'h' as c -> Some ((int_of_char c) - 97, -1)
        | '1' .. '8' as c -> Some (-1, (int_of_char c) - 49)
        | _ -> None
      in
      if 0 <= x && x <= 7 && 0 <= y && y <= 7 then
        Option.bind p
          (fun p ->
            if placement then Some (Placement (p, (x, y)))
            else if non_ambigu then Option.map (fun dep -> NonAmbigu(dep, p, (x, y))) ambigu_info
            else Some (Arrivee (p, (x, y))))
      else None
