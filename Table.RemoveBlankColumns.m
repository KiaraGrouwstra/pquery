/*
    // Allows to remove blank (empty) columns from a table like "Remove Empty Rows" UI option. 
    // Optional parameter for empty strings ("") removing (also as nulls)

    // Usage:
        Table.RemoveBlankColumns = Load("Table.RemoveBlankColumns"),
        
        // remove column with nulls AND empty strings:
        Table.RemoveBlankColumns(Table.FromRecords({[A = null, B = 1],[A = null, B = 2],[A = "", B = 3]}), true)
    // Result: Table.FromRecords({[B = 1],[B = 2],[B = 3]})

        // remove column with nulls only:
        Table.RemoveBlankColumns(Table.FromRecords({[A = null, B = 1],[A = null, B = 2],[A = "", B = 3]}))
    // Result: Table.FromRecords({[A = null, B = 1],[A = null, B = 2],[A = "", B = 3]})

*/

(
    tab as table, // table to clean
    optional EmptStr as nullable logical // flag to remove columns which contains nulls OR empty strings - only
) as table =>

    let
        ToRemove = {null} & (if EmptStr = true then {""} else {}), // list of "blank" values 
        tabDemoted = Table.DemoteHeaders(tab),
        tabTransposed = Table.Transpose(tabDemoted),
        RowsRemoved = Table.SelectRows(
            tabTransposed, 
            each not List.IsEmpty(
                List.RemoveMatchingItems(
                    Record.FieldValues(Record.RemoveFields(_, "Column1")), // after demote+transpose first column is allways with columns headers
                    ToRemove)
                )
            ),
        tabTransposedAgain = Table.Transpose(RowsRemoved)
        
    in
        Table.PromoteHeaders(tabTransposedAgain)

/* 
// Alternative version (performance didn't checked between versions):

    let
        ToRemove = {null} & (if EmptStr = true then {""} else {}) // list of "blank" values 
        
    in
        List.Accumulate(
            Table.ColumnNames(tab), 
            tab, 
            (state, current)=> 
                if List.IsEmpty(
                    List.RemoveMatchingItems(
                        Table.Column(state, current), 
                        ToRemove)
                    ) 
                then Table.RemoveColumns(state, current) 
                else state
            )
*/
