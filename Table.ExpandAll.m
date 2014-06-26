/*
//Fully expands any nested records and tables within a table
//Originally written by Chris Webb: https://cwebbbi.wordpress.com/2014/05/21/expanding-all-columns-in-a-table-in-power-query/
//Usage:
    Table.ExpandAll = Load("Table.ExpandAll"),
    xml = Xml.Tables("<books><book><name>Book1</name><pages><page>1</page><page>2</page><page>3</page></pages></book><book><name>Book2</name><pages><page>1</page><page>2</page><page>3</page></pages></book></books>"),
    Table.ExpandAll(xml)	//, null, false
//Result: [an expanded version of the given table with nested records/tables]
*/

let Table.ExpandAll = (TableToExpand as table, optional ColumnNumber as number, optional AppendParentNames as logical) =>
let
	ColumnNumber = if (ColumnNumber=null) then 0 else ColumnNumber,
	AppendParentNames = if (AppendParentNames=null) then true else AppendParentNames
in

List.Last(
	List.Generate(
		()=>[
			col = ColumnNumber,
			Tbl = TableToExpand
		],
		each [col]<=(Table.ColumnCount([Tbl])-1),
		each let
			ColumnName = Table.ColumnNames([Tbl]){[col]},
			ColumnsToExpand = List.Distinct(List.Combine(List.Transform(Table.Column([Tbl], ColumnName),
				each if _ is table then Table.ColumnNames(_) else {}))),
			NewColumnNames = List.Transform(ColumnsToExpand, each if AppendParentNames then ColumnName & "." & _ else _),
			CanExpandCol = List.Count(ColumnsToExpand)>0
		in [
			Tbl = if CanExpandCol
				then Table.ExpandTableColumn([Tbl], ColumnName, ColumnsToExpand, NewColumnNames)
				else [Tbl],
			col = if CanExpandCol
				then [col]
				else [col]+1
		],
		each [Tbl]
	)
)

in
    Table.ExpandAll
