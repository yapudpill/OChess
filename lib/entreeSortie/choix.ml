let choix msg l =
  let len = List.length l in
  let rec boucle () =
    print_string "Choix > ";
    match read_int_opt () with
    | None -> print_endline "Entrée incorrecte"; boucle ()
    | Some nb ->
        if 1 <= nb && nb <= len then snd @@ List.nth l (nb - 1)
        else (print_endline "Entrée incorrecte"; boucle ())
  in
  print_endline msg;
  List.iteri (fun i (s, _) -> Printf.printf "\t%d. %s\n" (i + 1) s) l;
  boucle ()
