This test is enabled both on 5.0.0 and 5.1.0. The test makes sense for as long
as the ppxlib AST is either 5.0.0 or 5.1.0. While the ppxlib AST is on 5.0.0, the
test checks whether parsing on 5.0.0 (result of test running on 5.0.0) is the same as
parsing on 5.1.0 and then migrating down to 5.0.0 (result of test running on 5.1.0).

The test is mostly useful for debuggung problems in a full round-trip.

  $ echo "let x : int = 5" > file.ml
  $ ./identity_driver.exe -dparsetree file.ml
  [ Pstr_value
      ( Nonrecursive
      , [ { pvb_pat = Ppat_var "x"
          ; pvb_expr = Pexp_constant (Pconst_integer ( "5", None))
          ; pvb_constraint =
              Some
                (Pvc_constraint
                   { locally_abstract_univars = []
                   ; typ = Ptyp_constr ( Lident "int", [])
                   })
          ; pvb_attributes = __attrs
          ; pvb_loc = __loc
          }
        ]
      )
  ]

  $ cat > file.ml << EOF
  > module F () = struct end
  > module M = F ()
  > EOF

  $ ./identity_driver.exe -dparsetree file.ml
  [ Pstr_module
      { pmb_name = Some "F"
      ; pmb_expr = Pmod_functor ( Unit, Pmod_structure [])
      ; pmb_attributes = __attrs
      ; pmb_loc = __loc
      }
  ; Pstr_module
      { pmb_name = Some "M"
      ; pmb_expr = Pmod_apply_unit (Pmod_ident (Lident "F"))
      ; pmb_attributes = __attrs
      ; pmb_loc = __loc
      }
  ]
