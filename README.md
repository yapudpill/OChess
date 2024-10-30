# OChess

*Un jeu d'échecs dans le terminal par Marc Robin et Anthony Fernandes*


[![pipeline status](https://moule.informatique.univ-paris-diderot.fr/marc-anthony-ocaml/ochess/badges/master/pipeline.svg)](https://moule.informatique.univ-paris-diderot.fr/marc-anthony-ocaml/ochess/-/commits/master)
[![coverage report](https://moule.informatique.univ-paris-diderot.fr/marc-anthony-ocaml/ochess/badges/master/coverage.svg)](https://moule.informatique.univ-paris-diderot.fr/marc-anthony-ocaml/ochess/-/commits/master)

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

Une fois les dépendances installées, le jeu peut être compilé avec `dune build`
et exécuté avec `dune exec ochess`.

## Tests et couverture

Ce projet utilise Alcotest pour gérer les tests unitaires et bisect_ppx pour
générer les rapports de couverture.

Les tests simples peuvent être exécutés avec `dune test`.

Afin de générer un rapport de couverture, utilisez les commandes suivantes :

```bash
# Exécution de tous les tests avec génération des artefacts pour bisect_ppx
dune test --instrument-with bisect_ppx --force

# Générer un rapport html dans le dossier _coverage
bisect-ppx-report html

# Afficher un résumé dans le terminal
bisect-ppx-report summary
```