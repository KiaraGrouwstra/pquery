// Function gets list of non-working days (weekends and official holidays) 
// from official source "Open Data" managed by Analytical Center of Russian Federation
//
// Function has two arguments - From_Year, To_Year
// which allows to restrict period of time that you need for your data model.
//
// Usage:
//  List.Dates.HolidaysRU( 2015, 2016 )
// Response:
//   List of non-working days in Russian Federations for years 2015 and 2016

(from_year as number, to_year as number) =>
	let
		fGetLatestURL = 
			let
				Source = Table.FromColumns({Lines.FromBinary(Web.Contents("http://data.gov.ru/node/19107/code-passport"))}),
				#"Filtered Rows" = Table.SelectRows(Source, each Text.Contains([Column1], "Гиперссылка (URL) на набор")),
				#"Get Text with URL" = #"Filtered Rows"{0}[Column1],
				#"Position of HTTP" = Text.PositionOf(#"Get Text with URL", "http"),
				#"Position of CSV" = Text.PositionOf( #"Get Text with URL", ".csv" ),
				URL = Text.Range( #"Get Text with URL", #"Position of HTTP", #"Position of CSV" - #"Position of HTTP" + 4 )
			in
				URL,

		Source = Csv.Document(Web.Contents( fGetLatestURL ),[Delimiter=",", Columns=13, Encoding=65001, QuoteStyle=QuoteStyle.None]),		
		#"Promoted Headers" = Table.PromoteHeaders( Source ),
		#"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Год/Месяц", Int64.Type}}),
		#"Filtered Rows1" = Table.SelectRows(#"Changed Type", each [#"Год/Месяц"] >= from_year and [#"Год/Месяц"] <= to_year ),
		#"Renamed Columns1" = Table.RenameColumns(#"Filtered Rows1",{{"Январь", "1"}, {"Февраль", "2"}, {"Март", "3"}, {"Апрель", "4"}, {"Май", "5"}, {"Июнь", "6"}, {"Июль", "7"}, {"Август", "8"}, {"Сентябрь", "9"}, {"Октябрь", "10"}, {"Ноябрь", "11"}, {"Декабрь", "12"}, {"Год/Месяц", "Год"}}),
		#"Unpivoted Other Columns" = Table.UnpivotOtherColumns(#"Renamed Columns1", {"Год"}, "Attribute", "Value"),
		#"Split Column by Delimiter" = Table.SplitColumn(#"Unpivoted Other Columns","Value",Splitter.SplitTextByDelimiter(",", QuoteStyle.Csv) ),
		#"Unpivoted Other Columns1" = Table.UnpivotOtherColumns(#"Split Column by Delimiter", {"Год", "Attribute"}, "Attribute.1", "Value"),
		#"Removed Columns" = Table.RemoveColumns(#"Unpivoted Other Columns1",{"Attribute.1"}),
		#"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"Attribute", "Месяц"}, {"Value", "День"}}),
		#"Filtered Rows" = Table.SelectRows(#"Renamed Columns", each not Text.Contains([День], "*")),
		#"Changed Type1" = Table.TransformColumnTypes(#"Filtered Rows",{{"Месяц", Int64.Type}, {"День", Int64.Type}}),
		#"Added Custom" = Table.AddColumn(#"Changed Type1", "Date", each #date( [Год], [Месяц], [День] ), type date),
		#"Removed Other Columns1" = Table.SelectColumns(#"Added Custom",{"Date"})

	in
		#"Removed Other Columns1"
