let MergeColumns = (Source, aCol, bCol) => let
    colName = "SomeCustomColName",
    InsertedCustom = Table.AddColumn(Source, colName, each if Record.Field(_,aCol)=null then Record.Field(_,bCol) else Record.Field(_,aCol) ),
    RemovedColumns = Table.RemoveColumns(InsertedCustom,{aCol, bCol}),
    RenamedColumns = Table.RenameColumns(RemovedColumns,{{colName, aCol}})
in RenamedColumns
in MergeColumns
