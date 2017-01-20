/*
  Function returns a table with ID and Country Name used on service http://timeanddate.com
*/

let
	Source = Table.FromColumns({Lines.FromBinary(Web.Contents("http://www.timeanddate.com/calendar/"))}),
	#"Filtered Rows" = Table.SelectRows(Source, each Text.Contains([Column1], "select id")),
	FullText = #"Filtered Rows"{0}[Column1],
	SelectText = Text.Range( FullText, Text.PositionOf( FullText, "<select"), Text.PositionOf( FullText, "</select" ) - Text.PositionOf( FullText, "<select" ) ),
	TextToList = Text.Split( SelectText, "option value="),
	#"Removed First Row" = List.Skip(TextToList,1),
	#"Replaced Closing Tag" = List.ReplaceValue(#"Removed First Row","</option><","",Replacer.ReplaceText),
	#"Converted to Table" = Table.FromList(#"Replaced Closing Tag", Splitter.SplitByNothing(), null, null, ExtraValues.Error),
	#"Split ID and Name" = Table.SplitColumn(#"Converted to Table","Column1",Splitter.SplitTextByEachDelimiter({">"}, QuoteStyle.Csv, false),{"ID", "Country"}),
	#"Replaced 'selected'" = Table.ReplaceValue(#"Split ID and Name"," selected","",Replacer.ReplaceText,{"ID"}),
	#"Replaced Last Closing Tag" = Table.ReplaceValue(#"Replaced 'selected'","</option>","",Replacer.ReplaceText,{"Country"}),
	#"Removed Duplicates" = Table.Distinct(#"Replaced Last Closing Tag"),
	#"Sorted Rows" = Table.Sort(#"Removed Duplicates",{{"Country", Order.Ascending}})
in
	#"Sorted Rows"
