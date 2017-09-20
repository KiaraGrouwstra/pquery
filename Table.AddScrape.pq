/*
//Add a column based on sequentially scraped results to a table. It's like Table.AddColumn() + Web.Contents(), except combining those directly would rape the server rather than inserting proper politeness delays.
//Usage:

let
    Web.AddScrape = Load("Web.AddScrape"),
    BaseUrl = "http://example.com/?p=",
    Pages = List.Numbers(1, 5),
    Tbl = Table.FromList(Pages),
in
    Web.AddScrape(Tbl, "Value", BaseUrl)

//Result: [a table with the response bodies of the URLs with the given variables added into a new column]
*/

(
    Tbl as table,                   //the table in question to add scrape results to
    Col as text,                    //the column of variable content to append to the base URL
    BaseUrl as text,                //the base URL
    optional newColName as text,    //the name of the new column to be added, default Content
    optional Delay as number,       //in seconds, default 1
    optional Encoding as number,    //https://msdn.microsoft.com/en-us/library/windows/desktop/dd317756(v=vs.85).aspx
    optional Options                //see options in Web.FetchSequentially
) as table =>
let
    newColName = if (newColName<>null) then newColName else "Content",
    Web.FetchSequentially = Load("Web.FetchSequentially"),

    InputList = Table.Column(Tbl, Col),
    DedupedList = List.Distinct(InputList),
    InputUrls = List.Transform(DedupedList, each BaseUrl & Expression.Constant(_)),
    ScrapedList = Web.FetchSequentially(InputUrls, Delay, Encoding, Options),
    ScrapedRecord = Record.FromList(ScrapedList, DedupedList),
    Merged = Table.AddColumn(Tbl, newColName, each Record.Field(ScrapedRecord, Record.Field(_, Col))),
    Buffered = Table.Buffer(Merged),

    Return = Buffered
in
    Return

