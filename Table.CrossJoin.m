/*
//Returns the Cartesian product (i.e. crossjoin) of two arguments (can be lists or tables).
//Usage:
    Table.CrossJoin = Load("Table.CrossJoin"),
    Table.CrossJoin({"A","B"},{1..3})	//list version
	TableA = Table.FromRecords({[A="A"],[A="B"]}),
	TableA = Table.FromRecords({[B=1],[B=2],[B=3]}),
    Table.CrossJoin(TableA, TableB)		//table version
//Result: Table.FromRecords({[A="A", B=1], [A="A", B=2], [A="A", B=3], [A="B", B=1], [A="B", B=2], [A="B", B=3]})
*/

let Table.CrossJoin = (A as any, B as any) =>

let
    TableA = if A is table then A else Table.FromValue(A),
    TableB = if B is table then B else Table.FromValue(B),
    Renamed = if Table.HasColumns(TableA, "Value")
        then Table.RenameColumns(TableA, {"Value", "Original"})
        else TableA,
    Merged = Table.AddColumn(Renamed, "Table", each TableB),
    ColumnsToExpand = List.Distinct(List.Combine(List.Transform(Table.Column(Merged, "Table"), each if _ is table then Table.ColumnNames(_) else {}))),
    Expand = Table.ExpandTableColumn(Merged, "Table", ColumnsToExpand)
in
    Expand
in Table.CrossJoin

