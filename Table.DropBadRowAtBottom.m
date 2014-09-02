/*
//Drops the last (bad) row of a given table. This is to solve a case where the last row went 'bad', meaning any evaluation of the row errors the query. The solution is to drop just the last row, but any regular functions to drop the last row or to count the number of rows fail due to evaluation of the cursed row.
//Usage:
    Table.DropBadRowAtBottom = Load("Table.DropBadRowAtBottom"),
	Tbl = #table({"A"},{{1},{error ":("}}),
    Table.DropBadRowAtBottom(Tbl)
//Result: #table({"A"},{{1}})
*/

let Table.DropBadRowAtBottom = (Tbl as table) =>

let
	Cols = Table.ColumnNames(Tbl),
	Columnized = Table.Column(Tbl,Cols{0}),
	RowsToKeep = List.Last(List.Generate(()=>[
			i = 1,
			lst = Columnized
		], each try not List.IsEmpty([lst]) otherwise false,
		each [
			i = [i] + 1,
			lst = List.Skip([lst])
		],
		each [i]
	)),
	Filtered = Table.Range(Tbl,0,RowsToKeep)
in
    Filtered
in Table.DropBadRowAtBottom

