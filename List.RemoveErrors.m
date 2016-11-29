(ListWithErrors as list) as list =>
/*
Takes list as input and returns the same list but without Error values.
Useful when errors came to list/column from external source, and there are no possibility to eliminate errors before using a list

Usage:
= List.RemoveErrors({1,2,error "this is an error",4})
returns
{1,2,4}
*/

let
    CleanList = Table.RemoveRowsWithErrors(Table.FromColumns({ListWithErrors}))[Column1]
in
    CleanList
