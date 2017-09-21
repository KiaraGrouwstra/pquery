let
    Source = M_library,
    Constants = Table.SelectRows(Source, each not Value.Is([Value], type type) and not Value.Is([Value], type function)),
    Return = Constants
in
    Return
