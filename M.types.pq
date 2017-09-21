let
    Source = M_library,
    Types = Table.SelectRows(Source, each Value.Is([Value], type type)),
    Return = Types
in
    Return
