module Make (R : Regles.Sig) = struct

  let obtenir_coup partie =
    let rec boucle () =
      Printf.printf "Votre coup > ";
      let str = read_line () in

      match EntreeSortie.Algebrique.from_string str with
      | None -> print_endline "Entrée invalide"; boucle ()
      | Some algebrique -> begin match R.coup_of_algebrique partie algebrique with
        | Ok coup -> coup
        | Error Invalide -> print_endline "Ce coup est illégal"; boucle ()
        | Error (Ambigu _) -> print_endline "Ce coup est ambigu"; boucle ()
      end
    in
    boucle ()


end