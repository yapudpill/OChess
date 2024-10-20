(lang dune 3.16)

(name OChess)

(generate_opam_files true)

(source (uri git+https://moule.informatique.univ-paris-diderot.fr/marc-anthony-ocaml/ochess))
(documentation https://moule.informatique.univ-paris-diderot.fr/marc-anthony-ocaml/ochess)
(homepage https://moule.informatique.univ-paris-diderot.fr/marc-anthony-ocaml/ochess)
(bug_reports https://moule.informatique.univ-paris-diderot.fr/marc-anthony-ocaml/ochess/-/issues)

(authors "Marc Robin" "Anthony Fernandes")

(maintainers "Marc Robin" "Anthony Fernandes")

(package
 (name OChess)
 (synopsis "Des échecs dans le terminal")
 (description "Une implémentations en OCaml d'un jeu d'échecs dans le terminal proposant plusieurs vairantes des règles.")
 (depends
    ocaml
    dune
    (alcotest :with-test))
 (tags (echecs)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
