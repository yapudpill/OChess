val choix : string -> (string * 'a) list -> 'a
(** Affiche un message et une liste d'options, puis demande à l'utilisateur de faire un choix parmi ces options.

    @param msg Le message à afficher avant la liste des options.
    @param l Une liste d'options sous forme de paires [(string, 'a)], où :
             - la chaîne de caractères représente la description de l'option,
             - la valeur associée représente l'élément correspondant au choix.
    @return La valeur ['a] associée à l'option sélectionnée par l'utilisateur.

    La fonction affiche chaque option avec un numéro, demande un choix en entrée,
    et répète la demande tant qu'une entrée valide (un nombre correspondant à une option) n'est pas fournie.*)