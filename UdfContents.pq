let
    UdfTable = Table.RenameColumns(Table.FromList(M_UDFs), {"Column1", "Name"}),
    WithContents = Table.AddColumn(UdfTable, "Contents", each getUdfContent([Name]))
in
    WithContents
