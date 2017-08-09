/*
// Cross-join a list of tables into one super table containing every combination of rows of its constituents
// Usage:
    Table.CrossJoinTables = Load("Table.CrossJoinTables"),
    Table.CrossJoinTables({
      #table({"A","B"},{{"A",1},{"B",2}}),
      #table({"C","D"},{{"E",3},{"F",4}})
    })
// Result: a cross-joined version of all the tables. beware of performance, the result could get big!
// Revision: Maxim Zelensky Aug 09, 2017
// Revision purpose: use Table.Join instead of Table.ExpandTableColumn (used in referenced function) to get performance gain
*/

(tables as list) as table =>
    let 
        CrossJoin = List.Accumulate(
            List.Positions(tables), 
            #table({},{}), 
            (state, current) => 
                let
                    CurrentTable = tables{current}, // need check for table type?
                    CurrentNames = Table.ColumnNames(state),
                    OldNames = Table.ColumnNames(CurrentTable),
                    NewNames = List.Transform(OldNames, each if List.Contains(CurrentNames, _) then Text.From(current+1) & "_" & _ else _),
                    Renamed = Table.RenameColumns(CurrentTable, List.Zip({OldNames, NewNames}))
                in
                    Table.Join(state, {}, Renamed, {}, JoinKind.FullOuter)
            )
    in
        if List.IsEmpty(tables) 
            then #table({},{}) 
            else CrossJoin
