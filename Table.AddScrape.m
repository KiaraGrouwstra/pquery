/*
//Add a column based on sequentially scraped results to a table. It's like Table.AddColumn() + Web.Contents(), except combining those directly would rape the server rather than inserting proper politeness delays.
//Usage:

let
    Web.FetchSequentially = Load("Web.FetchSequentially"),
    BaseUrl = "http://example.com/?p=",
    Pages = List.Numbers(1, 5),
    Urls = List.Transform(Pages, each BaseUrl & Number.ToText(_))
in
    Web.FetchSequentially(Urls)

//Result: [a list of decoded contents for each of the input URLs]
*/

(
	Tbl as table,					//the table in question to add scrape results to
	Col as text,					//the column of variable content to append to the base URL
	BaseUrl as text,				//the base URL
	optional newColName as text,	//the name of the new column to be added, default Content
    optional Delay as number,       //in seconds, default 1
    optional Encoding as number,    //https://msdn.microsoft.com/en-us/library/windows/desktop/dd317756(v=vs.85).aspx
    optional Options                //see options in Web.FetchSequentially
) as table =>
let
    newColName = if (newColName<>null) then newColName else "Content",
    Web.FetchSequentially = Load("Web.FetchSequentially"),

	InputList = Table.Column(Tbl, Col),
	InputUrls = List.Transform(InputList, each BaseUrl & Text.FromValue(_)),
	InputRecord = Record.FromList(InputList, InputUrls),
	DedupedKeys = Record.FieldNames(InputRecord),
	DedupedVals = Record.FieldValues(InputRecord),
	ScrapedList = Web.FetchSequentially(DedupedVals, Delay, Encoding, Options),
	ScrapedRecord = Record.FromList(DedupedKeys, ScrapedList),
	Merged = Table.AddColumn(Tbl, newColName, each Record.Field(ScrapedRecord, Record.Field(_, Col))),
	Buffered = Table.Buffer(Merged),

	Return = Buffered
in
	Return

