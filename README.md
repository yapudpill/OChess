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
et exécuté avec `dune exec -- ochess`.

**Note concernant les couleurs :** Nous avons remarqué que certains terminaux
(notamment celui intégré dans vscode) ne respectent pas séquence d'échappement
utilisées pour afficher les couleurs. Par soucis de compatibilité, les couleurs
peuvent être déactivées avec l'option `--no-colors`.

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

## Parallèle avec l'API suggérée en cours

Ce projet était déjà bien avancé quand l'API a été suggérée au premier TP, nous
avons donc gardé notre organisation, qui s'avère être finalement proche de
l'organisation proposée.

| API                            | Notre organisation                       |
| ------------------------------ | ---------------------------------------- |
| `type game_state + gamme_view` | `Jeu.Partie.t * Regles.Sig.infos`        |
| `type player + bot`            | Modules dans `joueurs`                   |
| `type play`                    | `Jeu.Partie.coup`                        |
| `type error`                   | `Jeu.Partie.erreur`                      |
| `type outcome`                 | Pas d'équivalent (*)                     |
| `val view`                     | Par nécessaire                           |
| `val display`                  | `EntreeSortie.Affichage.print_echiquier` |
| `val act`                      | `Regles.Sig.jouer`                       |

(*): La validité d'un coup est vérifiée par `coup_of_algebrique` et `est_legal`,
le résultat est obtenu avec `egalite` et `perdu`
