/*
//Makes a 'translated' column simultaneously executing multiple replaces on the original (using a list of lists as a 'translation sheet')
//Usage:
    Table.TranslateColumn = Load("Table.TranslateColumn"),
    Tbl = #table({"可能"},{{"不可"},{"可"}}),
    Table.TranslateColumn(Tbl, "可能", "Possible", {{"不可", "Nope"},{"可","Yes"}})
//Result: #table({"Possible"},{{"Nope"},{"Yes"}})
*/

(Tbl as table, OldCol as text, NewColName as text, TranslationList as list) as table =>

let
	ColAdded = Table.AddColumn(Tbl, NewColName, each List.ReplaceMatchingItems({Record.Field(_, OldCol)}, TranslationList)),
    Columnized = Table.ExpandListColumn(ColAdded, NewColName)
in 
    Columnized

