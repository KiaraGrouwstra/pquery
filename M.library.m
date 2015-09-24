let
    Source = Table.Sort(Record.ToTable(#shared),{{"Name", Order.Ascending}}),
    Categorized = Table.AddColumn(Source, "Status", each if Record.HasFields(#sections[Section1], [Name]) then "User defined" else "Built in"),
    // Annoying I need to filter out user defined stuff, but this resolves a cyclic reference caused if both F and this refer to all custom functions (which includes each other)
    Filtered = Table.SelectRows(Categorized, each [Status] = "Built in"),
    AddType = Table.AddColumn(Filtered, "Type", each Value_TypeToText([Value])),
    AddTypeRec = Table.AddColumn(AddType, "TypeRecurs", each Value_TypeToText([Value], true)),
    AddCat = Table.AddColumn(AddTypeRec, "Category", each
    let
        cut = Text.Split(Text.Replace([Name],"_","."),".")
    in
        (try
            if
                List.Contains({"Database", "Type"}, cut{1})
            then
                cut{1}
            else
                cut{0}
        otherwise
            "Custom"
        )
    ),
    Return = AddCat
in
    Return

