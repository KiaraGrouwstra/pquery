/*
//Merges two columns in a table that refer to the thing, taking column A but falling back to B where A is null
//Usage:
    Table.MergeColumns = Load("Table.MergeColumns"),
    Tbl = #table({"Tel.", "Phone #"},{{"234", null},{null, "123"}}),
    Table.MergeColumns(Tbl, "Tel.", "Phone #")
//Result: #table({"Tel."},{{"234"},{"123"}})
*/

(Source as table, aCol as text, bCol as text) as table => let
    colName = "SomeCustomColName",
    InsertedCustom = Table.AddColumn(Source, colName, each if Record.Field(_,aCol)=null then Record.Field(_,bCol) else Record.Field(_,aCol) ),
    RemovedColumns = Table.RemoveColumns(InsertedCustom,{aCol, bCol}),
    RenamedColumns = Table.RenameColumns(RemovedColumns,{{colName, aCol}})
in RenamedColumns

