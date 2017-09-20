/*
//Fully expands any nested tables within a table
//Originally written by Chris Webb: https://cwebbbi.wordpress.com/2014/05/21/expanding-all-columns-in-a-table-in-power-query/
//Usage:
    Table.ExpandTables = Load("Table.ExpandTables"),
    xml = Xml.Tables("<books><book><name>Book1</name><pages><page>1</page><page>2</page><page>3</page></pages></book><book><name>Book2</name><pages><page>1</page><page>2</page><page>3</page></pages></book></books>"),
    Table.ExpandTables(xml)    //, null, true
//Result: [an expanded version of the given table with nested tables]
*/

(
    TableToExpand as table,                    //the table you wish to expand
    optional ColumnNames as list,             //the columns to expand
    optional AppendParentNames as logical    //whether to use append parent column names e.g. "ul.li", or just keep "li" where possible (reverting to the qualified name in case of a colum name clash)
) as table =>
let
    ColumnNames = if (ColumnNames=null) then Table.ColumnNames(TableToExpand) else ColumnNames,
    count = List.Count(ColumnNames),
    AppendParentNames = if (AppendParentNames=null) then false else AppendParentNames
in

List.Last(
    List.Generate(
        ()=>[
            i = 0,
            Tbl = TableToExpand
        ],
        each [i] <= count,
        each let
            ColumnName = ColumnNames{[i]},
            ColumnsToExpand = List.Distinct(List.Combine(List.Transform(Table.Column([Tbl], ColumnName),
                each if _ is table then Table.ColumnNames(_) else {}))),
            NewColumnNames = List.Transform(ColumnsToExpand, each if (AppendParentNames or List.Contains(ColumnNames,_)) then ColumnName & "." & _ else _),
            CanExpandCol = List.Count(ColumnsToExpand) > 0
        in [
            i = [i] + 1,
            Tbl = if CanExpandCol
                then Table.ExpandTableColumn([Tbl], ColumnName, ColumnsToExpand, NewColumnNames)
                else [Tbl]
        ],
        each [Tbl]
    )
)
