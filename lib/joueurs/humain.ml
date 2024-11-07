module Make (R : Regles.Sig) = struct
  open EntreeSortie
  open Jeu.Partie

  (* let lever_ambiguite algebrique deps =
    let open EntreeSortie.Algebrique in
    match algebrique with

    | Grand_Roque | Petit_Roque -> failwith "Les roques ne sont pas ambigus"
    | Placement _ -> failwith "Les placements ne sont pas ambigus"
    | Arrivee (p, arr) ->
        let possibles =
          List.map
            (fun dep -> to_string (Arrivee (p, dep)), Mouvement (dep, arr))
            deps
        in
        Choix.choix "Ce coup est ambigu, de quel départ s'agit-il ?" possibles *)


  let obtenir_coup (partie, infos) =
    let rec boucle () =
      Printf.printf "Votre coup > ";
      let str = read_line () in

      match Algebrique.from_string str with
      | None -> print_endline "Entrée invalide"; boucle ()
      | Some algebrique ->
          match R.coup_of_algebrique (partie, infos) algebrique with
          | Ok coup -> coup
          | Error Invalide -> print_endline "Ce coup est illégal"; boucle ()
          | Error (Ambigu _) -> print_endline "Ce coup est illégal"; boucle ()
    in
    boucle ()
end
