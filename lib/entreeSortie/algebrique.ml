type t =
| Petit_Roque
| Grand_Roque
| Arrivee of Jeu.Piece.ptype * (int * int)
| Placement of Jeu.Piece.ptype * (int * int)
| Ambigu of int*string * Jeu.Piece.ptype * (int * int)

let to_string =
  let aux p (x, y) =
    Printf.sprintf "%c%c%c"
      (Affichage.char_of_piece p)
      (char_of_int (97 + x)) (* 97 est le code ascii de 'a' *)
      (char_of_int (49 + y)) (* 49 est le code ascii de '1' *)
  in
  function
  | Petit_Roque -> "O-O"
  | Grand_Roque -> "O-O-O"
  | Placement (p, pos) -> "@" ^ aux p pos
  | Arrivee (p, pos) -> aux p pos
  | Ambigu _ -> "blablabla"


  let from_string str =
    let len = String.length str in
    if len = 4 && str.[0] <> '@' then
      let piece_opt = Affichage.piece_of_char (Char.uppercase_ascii str.[0]) in
      let ambigu_info =
        if Char.code str.[1] >= Char.code 'a' && Char.code str.[1] <= Char.code 'h' then
          (* Ambiguïté par colonne de départ *)
          Some (-1, String.make 1 str.[1])
        else if Char.code str.[1] >= Char.code '1' && Char.code str.[1] <= Char.code '8' then
          (* Ambiguïté par ligne de départ *)
          Some (int_of_char str.[1] - 49, "")
        else
          None
      in
      match piece_opt, ambigu_info with
      | Some p, Some (ligne_depart, col_depart) ->
          let x = int_of_char (Char.lowercase_ascii str.[2]) - 97 in
          let y = int_of_char str.[3] - 49 in
          if 0 <= x && x <= 7 && 0 <= y && y <= 7 then
            Some (Ambigu (ligne_depart, col_depart, p, (x, y)))
          else
            None
      | _ -> None
    else
      (* Gestion des autres cas *)
      match str with
      | "o-o" | "O-O" -> Some Petit_Roque
      | "o-o-o" | "O-O-O" -> Some Grand_Roque
      | _ ->
          if len < 2 || len > 4 || (len = 4 && str.[0] <> '@') then None
          else
            let placement = str.[0] = '@' in
            let x = int_of_char (Char.lowercase_ascii str.[len - 2]) - 97 in
            let y = int_of_char str.[len - 1] - 49 in
            let p =
              if len = 2 || (len = 3 && placement) then Some Jeu.Piece.Pion
              else Affichage.piece_of_char (Char.uppercase_ascii str.[len - 3])
            in
            if 0 <= x && x <= 7 && 0 <= y && y <= 7 then
              Option.map
                (fun p -> if placement then Placement (p, (x, y)) else Arrivee (p, (x, y)))
                p
            else None

