/*
// Cross-join a list of tables into one super table containing every combination of rows of its constituents
// Usage:
  Table.CrossJoinTables = Load("Table.CrossJoinTables"),
  Table.CrossJoinTables({
    #table({"A","B"},{{"A",1},{"B",2}}),
    #table({"C","D"},{{"E",3},{"F",4}})
  })
// Result: a cross-joined version of all the tables. beware of performance, the result could get big!
*/

(
  tables as list,
  optional TableNames as list, // names to append as prefixes on clash or if desired, default {1, 2, 3, ...}
  optional AlwaysPrefix as logical    //whether to use append table names if without column name clashes
) as table => let
  CrossJoin = List.Accumulate(
    List.Positions(tables),
    #table({},{}), 
    (state, current) => let
      CurrentTable = tables{current}, // need check for table type?
      CurrentNames = Table.ColumnNames(state),
      OldNames = Table.ColumnNames(CurrentTable),
      Prefix = if TableNames <> null then try TableNames{current} otherwise Text.From(current+1) else Text.From(current+1),
      NewNames = List.Transform(OldNames, each if AlwaysPrefix or List.Contains(CurrentNames, _) then Prefix & "_" & _ else _),
      Renamed = Table.RenameColumns(CurrentTable, List.Zip({OldNames, NewNames}))
    in
      Table.Join(state, {}, Renamed, {}, JoinKind.FullOuter)
    )
  in
    if List.IsEmpty(tables) 
      then #table({},{}) 
      else CrossJoin
