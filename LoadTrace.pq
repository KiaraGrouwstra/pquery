//Original made by Chris Webb:
//http://blog.crossjoin.co.uk/2014/12/11/reading-the-power-query-trace-filewith-power-query/
(Path as text) as table =>
let
    Source = Table.FromColumns({Lines.FromBinary(File.Contents(Path))}),
    Json = Table.TransformColumns(Source, {{"Column1", each Json.Document(Text.Split(_, " : "){1})}}),
    Expanded = Table.ExpandRecordColumn(Json, "Column1", {"Start","Action","Duration","Exception","CommandText","ResponseFieldCount","PackageReference","ProductVersion","ActivityId","Process","Pid","Tid"}),
    Typed = Table.TransformColumnTypes(Expanded, {{"Start", type datetime}, {"Duration", type duration}})
in
    Typed
