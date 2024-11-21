# OChess

*Un jeu d'échecs dans le terminal par Marc Robin et Anthony Fernandes*

[![pipeline status](https://moule.informatique.univ-paris-diderot.fr/marc-anthony-ocaml/ochess/badges/master/pipeline.svg)](https://moule.informatique.univ-paris-diderot.fr/marc-anthony-ocaml/ochess/-/commits/master)
[![coverage report](https://moule.informatique.univ-paris-diderot.fr/marc-anthony-ocaml/ochess/badges/master/coverage.svg)](https://moule.informatique.univ-paris-diderot.fr/marc-anthony-ocaml/ochess/-/commits/master)

## Installation

### Installation manuelle

Si vous ne souhaitez pas suive les instructions d'installation qui vont suivre,
voici la liste des dépendances de notre projet :
- `dune`
- `alcotest` (tests)
- `bisect_ppx` (tests)

### Compilation et exécution (sans tests)

Ce jeu nécessite le package manager d'ocaml, [opam](https://opam.ocaml.org).

Une fois opam installé, utilisez les commandes suivantes dans le répertoire où
se trouve de README pour installer les dépendances nécessaires à l'execution :

```bash
# Créé un switch opam local avec les dépendances du projet hors tests
opam switch create . 5.2.0 --deps-only

# Mettre à jour les variables de l'environnement pour utiliser le switch local
eval $(opam env)
```

Une fois les dépendances installées, le jeu peut être compilé avec
`dune build bin/main.exe` et exécuté avec `dune exec -- ochess`.

Un [FEN](https://fr.wikipedia.org/wiki/Notation_Forsyth-Edwards) (une notation
compressée de l'état d'une partie) peut également être précisé en argument de
la ligne de commande pour charger une partie arbitraire. Ça donne par exemple
`dune exec -- ochess "r1bqk2r/pppp1ppp/2n2n2/2b1p3/2BPP3/2P2N2/PP3PPP/RNBQK2R w - -"`

**Note concernant les couleurs :** Nous avons remarqué que certains terminaux
(notamment celui intégré dans vscode) ne respectent pas les séquences
d'échappement ANSI utilisées pour afficher les couleurs. Par soucis de
compatibilité, les couleurs peuvent être désactivées avec l'option `--no-colors`,
donnant donc `dune exec -- ochess --no-colors`.

### Tests et couverture

Ce projet utilise `alcotest` pour gérer les tests unitaires et `bisect_ppx` pour
générer les rapports de couverture.

Utilisez la commandes suivantes pour ajouter les dépendances de tests au switch
local :

```bash
opam install . --deps-only --with-test
```

Le projet et les tests peuvent maintenant être compilés avec `dune build`.
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

## Comment jouer

### Format des Inputs

Pour permettre une interaction fluide et faciliter le déroulement de la partie,
nous avons fixé une notation standard pour les coups. Nous utilisons une version
simplifiée de la notation algébrique classique, en respectant les conventions
françaises pour les noms des pièces :

- **Tour** : T
- **Cavalier** : C
- **Fou** : F
- **Dame** : D
- **Roi** : R

#### Notation des coups
Un coup se note sous la forme : `<nom de la pièce><case d'arrivée>`

Pour un coup de pion, il est permis (et même conseillé) d’omettre le nom de
la pièce.

Pour les roques, la notation est la suivante :

- **Petit roque** : `o-o`
- **Grand roque** : `o-o-o`

#### Exemple
Voici un exemple de partie avec la notation de coups :

    1. e4 e5
    2. Cf3 Cc6
    3. Fb5 Cf6
    4. o-o Ce4
    5. d4 Cd6

**État de la partie :**

```
8  ♖  .  ♗  ♕  ♔  ♗  .  ♖
7  ♙  ♙  ♙  ♙  .  ♙  ♙  ♙
6  .  .  ♘  ♘  .  .  .  .
5  .  ♝  .  .  ♙  .  .  .
4  .  .  .  ♟  .  .  .  .
3  .  .  .  .  .  ♞  .  .
2  ♟  ♟  ♟  .  .  ♟  ♟  ♟
1  ♜  ♞  ♝  ♛  .  ♜  ♚  .
   A  B  C  D  E  F  G  H
```

#### Gestion des ambiguïtés

Certaines positions peuvent entraîner des ambiguïtés. Par exemple, après la
séquence de coups ci-dessus, un coup comme `Fc6` serait ambigu car les pions `b`
et `d` peuvent tout deux capturer en `c6`. Dans ce cas, le joueur doit spécifier
la pièce voulue.

- **Pions** : Pour lever l’ambiguïté, précisez `P` et la colonne d’origine
  (ex. `Pdc6` pour le pion `d` allant en `c6`).
- **Autres pièces** : Si une case est atteignable par plusieurs pièces de même
  type, on ajoute la colonne ou la ligne d'origine après la pièce.
    - Exemple avec les Cavaliers : Si un Cavalier est en `f3` et un autre en
      `b1`, `Cd2` serait ambigu. Il faudra noter `Cfd2` ou `Cbd2` pour désigner
      le Cavalier souhaité.
    - Exemple avec les lignes : Si un Cavalier est en `e3` et un autre en `e5`,
      `Cf4` serait ambigu. On notera alors `C3f4` ou `C5f4` selon le Cavalier
      choisi.

Cette notation s'applique également aux autres pièces telles que la Tour ou la
Dame (après une promotion, par exemple) pour éviter toute ambiguïté.


### Règles des Variantes d'Échecs proposées

#### 1. Échecs Classiques

Les échecs classiques sont un jeu de stratégie où deux joueurs, les Blancs et
les Noirs, s'affrontent sur un plateau de 8x8 cases. L'objectif est de mettre le
roi adverse en **échec et mat**, c’est-à-dire de l’attaquer de façon à ce qu'il
ne puisse échapper à la capture.

- **Déplacement des pièces** :
  - **Roi** : Une case dans n'importe quelle direction.
  - **Dame** : Diagonale, horizontale ou verticale sur n’importe quelle distance.
  - **Tour** : Horizontalement ou verticalement sur n’importe quelle distance.
  - **Fou** : Diagonalement sur n’importe quelle distance.
  - **Cavalier** : Déplacement en "L" (deux cases dans une direction, puis une
    case perpendiculairement).
  - **Pion** : Avance d'une case vers l’avant, ou de deux cases s'il s'agit de
    son premier mouvement ; capture en diagonale.

- **Règles spéciales** :
  - **Roque** : Permet de déplacer le roi de deux cases vers une tour pour mieux
    protéger le roi.
    - **Restrictions du roque** : Le roque n'est pas autorisé si le roi est en
      échec, s'il doit traverser une case menacée, ou s'il doit se retrouver en
      échec après le déplacement.
  - **Prise en passant** : Capture d’un pion adverse qui a avancé de deux cases
    depuis sa case de départ.
  - **Promotion** : Un pion qui atteint la dernière rangée peut être promu
    (souvent en Dame).

#### 2. Roi de la Colline

Dans la variante **Roi de la Colline**, les règles des échecs classiques
s'appliquent, mais un objectif supplémentaire est ajouté : amener son roi au
centre du plateau.

- **Objectif** : Le premier joueur à placer son roi sur l'une des quatre cases
  centrales (`d4`, `d5`, `e4`, `e5`) remporte la partie.
- **Mise en échec et mat** : Les joueurs peuvent également gagner en mettant le
  roi adverse en échec et mat, comme dans les échecs classiques.
- **Restrictions de roque** : Les mêmes restrictions s'appliquent que pour les
  échecs classiques : le roque est impossible si le roi est en échec ou doit
  traverser une case attaquée.
- **Stratégie** : Ce mode ajoute une nouvelle dimension stratégique en poussant
  les joueurs à équilibrer les attaques tout en se rapprochant du centre.

### 3. Trois Échecs

Dans la variante **Trois Échecs**, l’objectif est de donner échec trois fois à
l’adversaire pour remporter la partie.

- **Objectif** : Gagner en mettant l’adversaire en échec trois fois, sans
  forcément arriver à un échec et mat.
- **Notation des échecs** : Chaque échec est compté et indiqué.
- **Règles** : Toutes les règles des échecs classiques s'appliquent, et le roque
  reste soumis aux mêmes restrictions.
- **Stratégie** : Les joueurs sont souvent amenés à provoquer des échecs
  rapidement, parfois en sacrifiant des pièces pour atteindre le troisième échec.

### 4. Crazyhouse

La variante **Crazyhouse** ajoute un aspect unique aux échecs en permettant aux
joueurs de remettre en jeu les pièces capturées.

- **Objectif** : Comme dans les échecs classiques, le but est de mettre le roi
  adverse en échec et mat.
- **Règle de capture** : Lorsqu'un joueur capture une pièce, il peut la remettre
  sur le plateau lors de son prochain tour.
- **Placement des pièces capturées** :
  - Les pièces capturées peuvent être placées sur n'importe quelle case libre.
  - Les pions ne peuvent pas être placés sur la première ou la dernière rangée.
- **Restrictions de roque** : Le roque est interdit si le roi est en échec ou
  doit passer par une case attaquée.
- **Stratégie** : Cette variante encourage les échanges agressifs et des
  positions dynamiques, car chaque pièce capturée peut rapidement devenir un
  atout pour l'adversaire.

Chaque variante d’échecs introduit des éléments stratégiques uniques, offrant
des expériences de jeu renouvelées et exigeant des adaptations dans la gestion
des pièces et de l'espace sur l’échiquier.

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
| `val view`                     | Pas nécessaire                           |
| `val display`                  | `EntreeSortie.Affichage.print_echiquier` |
| `val act`                      | `Regles.Sig.jouer`                       |

(*): La validité d'un coup est vérifiée par `coup_of_algebrique` et `est_legal`,
le résultat est obtenu avec `egalite` et `perdu`
