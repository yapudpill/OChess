# OChess

*Un jeu d'échecs dans le terminal par Marc Robin et Anthony Fernandes*

## Compilation et exécution

Ce jeu nécessite le package manager d'ocaml, [opam](https://opam.ocaml.org).

Une fois opam installé, utilisez les commandes suivantes dans le répertoire où
se trouve de README :

```bash
# Créé un switch opam local avec les dépendances du projet
opam switch create --deps-only --with-test --with-doc . 5.2.0

# Mettre à jour les variables de l'environnement pour utiliser le switch local
eval $(opam env)
```

Une fois les dépendances installées, le jeu peut être compilé avec `dune build`,
exécuté avec `dune exec OChess` testé avec `dune test`.