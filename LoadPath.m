let
    //Feel free to just put your own fixed path in here instead of using the table from this workbook!
    //Source = "D:\pquery\"
    Source = Excel.CurrentWorkbook(){[Name="Table1"]}[Content]{0}[Path]
in
    Source