let
    Table.CrossJoin = Load("Table.CrossJoin"),
    Tokens = Table.RenameColumns(Table.FromList(Record.FieldNames(#shared)), {"Column1", "Token"}),
    AddAlts = Table.AddColumn(Tokens, "TokenAlt", each Text.Replace([Token], "_", ".")),
    Crossed = Table.CrossJoin(AddAlts, UdfContents),
    Contained = Table.AddColumn(Crossed, "Contains", each Text.Contains([Contents], [Token]) or Text.Contains([Contents], [TokenAlt])),
    Filtered = Table.SelectRows(Contained, each [Contains]),
    FiltCols = Table.SelectColumns(Filtered, {"Token", "TokenAlt", "Name"}),
    Return = FiltCols
in
Return
