/*
//Fully expands any nested records and tables within a table
//Originally written by Chris Webb: https://cwebbbi.wordpress.com/2014/05/21/expanding-all-columns-in-a-table-in-power-query/
//Usage:
    Table.ExpandAll = Load("Table.ExpandAll"),
    xml = Xml.Tables("<books><book><name>Book1</name><pages><page>1</page><page>2</page><page>3</page></pages></book><book><name>Book2</name><pages><page>1</page><page>2</page><page>3</page></pages></book></books>"),
    Table.ExpandAll(xml)
//Result: [an expanded version of the given table with nested records/tables]
*/

//Define function taking two parameters - a table and an optional column number 
let Table.ExpandAll = (TableToExpand as table, optional ColumnNumber as number) =>
let
    Table.ExpandAll = Load("Table.ExpandAll"),

     //If the column number is missing, make it 0
     ActualColumnNumber = if (ColumnNumber=null) then 0 else ColumnNumber,
     //Find the column name relating to the column number
     ColumnName = Table.ColumnNames(TableToExpand){ActualColumnNumber},
     //Get a list containing all of the values in the column
     ColumnContents = Table.Column(TableToExpand, ColumnName),
     //Iterate over each value in the column and then
     //If the value is of type table get a list of all of the columns in the table
     //Then get a distinct list of all of these column names
     ColumnsToExpand = List.Distinct(List.Combine(List.Transform(ColumnContents, 
         each if _ is table then Table.ColumnNames(_) else {}))),
     //Append the original column name to the front of each of these column names
     NewColumnNames = ColumnsToExpand,   //List.Transform(ColumnsToExpand, each ColumnName & "." & _),
     //Is there anything to expand in this column?
     CanExpandCurrentColumn = List.Count(ColumnsToExpand)>0,
     //If this column can be expanded, then expand it
     ExpandedTable = if CanExpandCurrentColumn 
         then Table.ExpandTableColumn(TableToExpand, ColumnName, ColumnsToExpand, NewColumnNames) 
         else TableToExpand,
     //If the column has been expanded then keep the column number the same, otherwise add one to it
     NextColumnNumber = if CanExpandCurrentColumn then ActualColumnNumber else ActualColumnNumber+1,
     //If the column number is now greater than the number of columns in the table
     //Then return the table as it is
     //Else call the ExpandAll function recursively with the expanded table
     OutputTable = if NextColumnNumber>(Table.ColumnCount(ExpandedTable)-1) 
		then ExpandedTable 
		else Table.ExpandAll(ExpandedTable, NextColumnNumber)
in
     OutputTable
in
    Table.ExpandAll
