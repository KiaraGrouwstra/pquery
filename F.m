/*
F (short for function), like Load(), provides one calling interface to access functions either imported (faster) or loaded (fallback), so code could be left agnostic to whether the queries are available locally, though whether this is really necessary is left up to the user to decide. One reasonable use case would be allowing many workbooks to access a shared library of queries from their files without needing to import them to each workbook after every change.

Imported or loadable functions could be referenced as any of the following:
	Load("Text.ReplaceAll")
	Load("Text_ReplaceAll")
	F[Text.ReplaceAll]
	F[Text_ReplaceAll]

Intended benefits of F over Load():
	- shorter
	- may help avoiding duplicate executions of file imports (if applicable) -- needs further testing though.
*/

let
    Shared = #shared,


    //Record.Rename = Load("Record.Rename"),
    //Record.Rename = Record_Rename,
/*
    Record.Rename = (Rec as record, Lambda as function) as record =>
    let
        Keys = Record.FieldNames(Rec),
        Values = Record.FieldValues(Rec),
        Renamed = List.Transform(Keys, each Lambda(_, Record.Field(Rec, _))),
        Recorded = Record.FromList(Values, Renamed)
    in
        Recorded,
*/
    //cyclic reference...?
    //SharedPeriods = Record.Rename(Shared, (k,v) => Text.Replace(k, "_", ".")),

    SharedPeriods = Record.FromList(Record.FieldValues(Shared), List.Transform(Record.FieldNames(Shared), each Text.Replace(_, "_", "."))),

    SharedMerged = Record.Combine({Shared, SharedPeriods}),
    //If I can make a wrapper function to enable profiling/persistence, wrap these as well

    Files = Folder.Files(LoadPath),
    MFiles = Table.SelectRows(Files, each Text.Lower([Extension]) = ".m"
        // and [Folder Path] = LoadPath    // non-recursive
    ),
    NoExt = Table.TransformColumns(MFiles, {"Name", each Text.Start(_, Text.Length(_)-2)}),
    CustomNames = Table.Column(NoExt, "Name"),
    Underscored = List.Transform(CustomNames, each Text.Replace(_, ".", "_")),
    CustomBoth = List.Union({CustomNames, Underscored}),
    CustomLoaded = Record.FromList(List.Transform(CustomBoth, Load), CustomBoth),
    SharedAndLoaded = Record.Combine({CustomLoaded, SharedMerged}),

    Return = SharedAndLoaded
in
    Return

