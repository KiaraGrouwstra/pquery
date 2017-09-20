// originally created by Ken Puls
// http://www.excelguru.ca/blog/2015/01/28/creating-a-vlookup-function-in-power-query/

(lookup_value as any, table_array as table, col_index_number as number, optional approximate_match as logical ) as any =>

let
    /*Provide optional match if user didn't */
    matchtype = if approximate_match = null then true else approximate_match,

    /*Get name of return column */
    Cols = Table.ColumnNames(table_array),
    ColTable = Table.FromList(Cols, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    ColName_match = Record.Field(ColTable{0},"Column1"),
    ColName_return = Record.Field(ColTable{col_index_number - 1},"Column1"),

    /*Find closest match */
    SortData = Table.Sort(table_array,{{ColName_match, Order.Descending}}),
    RenameLookupCol = Table.RenameColumns(SortData,{{ColName_match, "Lookup"}}),
    RemoveExcess = Table.SelectRows(RenameLookupCol, each [Lookup] <= lookup_value),
    ClosestMatch=
    if Table.IsEmpty(RemoveExcess)=true
        then "#N/A"
        else Record.Field(RemoveExcess{0},"Lookup"),

    /*What should be returned in case of approximate match? */
    ClosestReturn=
    if Table.IsEmpty(RemoveExcess)=true
        then "#N/A"
        else Record.Field(RemoveExcess{0},ColName_return),

    /*Modify result if we need an exact match */
    Return =
    if matchtype=true
        then ClosestReturn
        else if lookup_value = ClosestMatch
            then ClosestReturn
            else "#N/A"

in
    Return

