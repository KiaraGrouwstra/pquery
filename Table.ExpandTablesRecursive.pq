/*
//Fully expands any nested tables within a table
//Originally written by Chris Webb: https://cwebbbi.wordpress.com/2014/05/21/expanding-all-columns-in-a-table-in-power-query/
//Usage:
    Table.ExpandTablesRecursive = Load("Table.ExpandTablesRecursive"),
    xml = Xml.Tables("<books><book><name>Book1</name><pages><page>1</page><page>2</page><page>3</page></pages></book><book><name>Book2</name><pages><page>1</page><page>2</page><page>3</page></pages></book></books>"),
    Table.ExpandTablesRecursive(xml)    //, null, true
//Result: [an expanded version of the given table with nested tables]
*/

(
    TableToExpand as table,                    //the table you wish to expand
    optional ColumnNumber as number,        //the column number to expand
    optional AppendParentNames as logical    //whether to use append parent column names e.g. "ul.li", or just keep "li" where possible (reverting to the qualified name in case of a colum name clash)
) as table =>
let
    ColumnNumber = if (ColumnNumber=null) then 0 else ColumnNumber,
    AppendParentNames = if (AppendParentNames=null) then false else AppendParentNames
in

List.Last(
    List.Generate(
        ()=>[
            col = ColumnNumber,
            Tbl = TableToExpand
        ],
        each [col]<=(Table.ColumnCount([Tbl])-1),
        each let
            ColumnNames = Table.ColumnNames([Tbl]),
            ColumnName = ColumnNames{[col]},
            ColumnsToExpand = List.Distinct(List.Combine(List.Transform(Table.Column([Tbl], ColumnName),
                each if _ is table then Table.ColumnNames(_) else {}))),
            NewColumnNames = List.Transform(ColumnsToExpand, each if (AppendParentNames or List.Contains(ColumnNames,_)) then ColumnName & "." & _ else _),
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

