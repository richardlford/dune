This test demonstrates that -ppx is no more missing when two stanzas are
in the same dune file, but require different ppx specifications

  $ ocamlc_where="$(ocamlc -where)"
  $ ENCODED_OCAMLC_WHERE=$(dune_cmd encode-prefix "$ocamlc_where")
  $ export BUILD_PATH_PREFIX_MAP=\
  > "/OCAMLC_WHERE=$ENCODED_OCAMLC_WHERE:$BUILD_PATH_PREFIX_MAP"

  $ dune build @all --profile release
  $ dune ocaml merlin dump-config $PWD
  Usesppx1
  ((STDLIB /workspace_root/lib/ocaml)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.usesppx1.objs/byte)
   (S
    $TESTCASE_ROOT)
   (FLG
    (-ppx
     "$TESTCASE_ROOT/_build/default/.ppx/c152d6ca3c7e1d83471ffdf48bf729ae/ppx.exe
     --as-ppx
     --cookie
     'library-name="usesppx1"'"))
   (FLG (-w -40 -g)))
  Usesppx2
  ((STDLIB /workspace_root/lib/ocaml)
   (EXCLUDE_QUERY_DIR)
   (B
    $TESTCASE_ROOT/_build/default/.usesppx2.objs/byte)
   (S
    $TESTCASE_ROOT)
   (FLG
    (-ppx
     "$TESTCASE_ROOT/_build/default/.ppx/d7394c27c5e0f7ad7ab1110d6b092c05/ppx.exe
     --as-ppx
     --cookie
     'library-name="usesppx2"'"))
   (FLG (-w -40 -g)))
