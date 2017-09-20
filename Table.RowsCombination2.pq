(tables as list) =>
let
 //   tables = { Table1, Table2, Table3, Table4, Table5 },    
    
    add_tables = List.Last(
        List.Generate( ()=>
            [i=0, T=tables{0}],
            each [i] <= List.Count( tables ) - 1,
            each [i=[i]+1,
                T= Table.AddColumn( [T], "Custom." & Text.From( i ), each tables{ i } ) ],
            each [T] ) ),
    
    expand_tables = List.Last(
        List.Generate( ()=>
            [i=0, T=add_tables],
            each [i] <=List.Count( tables ) - 1,
            each [i=[i]+1,
                T= Table.ExpandTableColumn( [T], 
                                            "Custom." & Text.From( i ), 
                                            Table.ColumnNames( tables{0} ), 
                                            List.Transform( Table.ColumnNames( tables{0} ), each Text.From(_) & "." & Text.From( i ) ) ) ],
            each [T] ) ),

    #"Added Index" = Table.AddIndexColumn(expand_tables, "Index", 1, 1),
    #"Unpivoted Other Columns" = Table.UnpivotOtherColumns(#"Added Index", {"Index"}, "Attribute", "NewValue"),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Unpivoted Other Columns","Attribute",Splitter.SplitTextByEachDelimiter({"."}, QuoteStyle.Csv, false),{"Attribute.1", "Attribute.2"}),
    #"Pivoted Column" = Table.Pivot(#"Split Column by Delimiter", List.Distinct(#"Split Column by Delimiter"[Attribute.1]), "Attribute.1", "NewValue"),
    #"Removed Columns" = Table.RemoveColumns(#"Pivoted Column",{"Attribute.2"})
in
    #"Removed Columns"
