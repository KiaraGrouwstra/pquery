/*
  Function returns a table with list of dates for specified years, and indicator for each day
  is it a working or non-working day in specified country.
  Argument Country requires specific ID, which can be received by another function
  https://github.com/IvanBond/pquery/blob/master/Web.TimeAndDateCom.GetCountries.m
  
  Sample Excel file:https://1drv.ms/x/s!AsARcUyPYj4LgqMAHv8GM3pe3ZE_Ug
*/

(   Country as text,
    Year1 as number, 
    Year2 as nullable number) =>

let

    Y2 = if Year2 = null then Year1 else Year2,

    Source = Table.FromColumns({Lines.FromBinary(Web.Contents("https://www.timeanddate.com/calendar/custom.html?mty=1&ctf=4&hol=9&typ=3&hod=7&holmark=1&display=2&cdt=1&wdf=3&mtm=2&cols=1&country=" & 
        Country & "&year=" & Text.From(Year1) & "&y2=" & Text.From(Y2) ))}),

    #"Filtered Rows" = Table.SelectRows(Source, each Text.Contains([Column1], "<div id=calarea>")),
    CalAreaText = #"Filtered Rows"{0}[Column1],
    Custom1 = Text.PositionOf( CalAreaText, "<table " ),
    Custom2 = Text.PositionOf( CalAreaText, "</table>", Occurrence.Last ),
    TableAsText = Text.Range( CalAreaText, Custom1, Custom2 - Custom1 + 8 ),
    CalTableAsList = Text.Split( TableAsText, "<tr>" ),
    #"Replaced Closing tr" = List.ReplaceValue(CalTableAsList,"</tr>","",Replacer.ReplaceText),
    #"Converted to Table" = Table.FromList(#"Replaced Closing tr", Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Filtered Target Rows" = Table.SelectRows(#"Converted to Table", each Text.Contains([Column1], "<td class=cn") or Text.Contains([Column1], "<td class=""cn") or Text.Contains([Column1], "<th>") ),
    #"Added Headers" = Table.AddColumn(#"Filtered Target Rows", "Titles", each if Text.Contains( [Column1], "<th>") then [Column1] else null),
    #"Added Days rows" = Table.AddColumn(#"Added Headers", "Day Rows", each if not Text.Contains( [Column1], "<th>") then [Column1] else null),
    #"Added Working Days Ind" = Table.AddColumn(#"Added Days rows", "Working Day", each if Text.Contains( [Column1], "cn  minititle") then "N" else "Y"),
    #"Added MM YYYY" = Table.AddColumn(#"Added Working Days Ind", "MM YYYY", each try Text.Range([Titles], Text.PositionOf([Titles], """>")+2, 7) otherwise null),
    #"Added Days Dirty" = Table.AddColumn(#"Added MM YYYY", "Days Dirty", each if [Day Rows] <> null then Text.Range([Day Rows], Text.PositionOf([Day Rows], ">")+1,2) else null),
    #"Clean Days Dirty" = Table.ReplaceValue(#"Added Days Dirty","<","",Replacer.ReplaceText,{"Days Dirty"}),
    #"Filled Down MM YYYY" = Table.FillDown(#"Clean Days Dirty",{"MM YYYY"}),
    #"Removed Other Columns" = Table.SelectColumns(#"Filled Down MM YYYY",{"Working Day", "MM YYYY", "Days Dirty"}),
    #"Filtered nulls" = Table.SelectRows(#"Removed Other Columns", each ([Days Dirty] <> null)),
    #"Convert to Date" = Table.AddColumn(#"Filtered nulls", "Date", each #date( Number.From(Text.End([MM YYYY],4)), Number.From(Text.Start([MM YYYY],2)), Number.From([Days Dirty]))),
    #"Removed Other Columns1" = Table.SelectColumns(#"Convert to Date",{"Date", "Working Day"}),
    #"Added Country" = Table.AddColumn(#"Removed Other Columns1", "Country", each Country),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Country",{"Country", "Date", "Working Day"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Reordered Columns",{{"Date", type date}, {"Working Day", type text}, {"Country", type text}}),
    #"Sorted Rows" = Table.Sort(#"Changed Type",{{"Date", Order.Ascending}})
in
    #"Sorted Rows"
