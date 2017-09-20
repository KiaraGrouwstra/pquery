let
    // text user-defined queries
    Files = Folder.Files(LoadPath), // Folder.Contents
    AddDecode = Table.AddColumn(Files, "Text", each Text.FromBinary([Content])),
    FilterCols = Table.SelectColumns(AddDecode, {"Name", "Text"}),
    TextCol = Table.Column(FilterCols, "Text"),
    TextMerged = Text.Combine(TextCol),
    TextCleaned = TextMerged, // sorry, no regex to clean out comments!
    Return = TextCleaned
in
    Return
