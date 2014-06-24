/*
//Makes a 'translated' column simultaneously executing multiple replaces on the original (using a list of lists as a 'translation sheet')
//Usage:
    Table.TranslateColumn = Load("Table.TranslateColumn"),
    Tbl = Table.FromRecords({ [可能="不可"], [可能="可"] }),
    Table.TranslateColumn(Tbl, "可能", "Possible", {{"不可", "Nope"},{"可","Yes"}})
//Result: Table.FromRecords({ [Possible="Nope"], [Possible="Yes"] })
*/

let Table.TranslateColumn = (Tbl as table, OldCol as text, NewColName as text, TranslationList as list) =>

let
	Renamed = Table.RenameColumns(Tbl, {OldCol, "TemporaryColumnName"}),
	//Don't know how to refer to a dynamically named column for within an each construction
	ColAdded = Table.AddColumn(Renamed, NewColName, each List.ReplaceMatchingItems({[TemporaryColumnName]}, TranslationList)),
	NamedBack = Table.RenameColumns(ColAdded, {"TemporaryColumnName", OldCol}),
    Columnized = Table.ExpandListColumn(NamedBack, NewColName)
in 
    Columnized
in
    Table.TranslateColumn

