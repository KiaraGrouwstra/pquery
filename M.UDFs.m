let
    Source = Record.FieldNames(#shared),
    UDFs = List.Select(Source, each Record.HasFields(#sections[Section1], _)),
    Return = UDFs
in
    Return
