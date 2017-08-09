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

(Tables as list) as table =>
let
  Table.ExpandTables = Load("Table.ExpandTables"),
  Cols = List.Transform(List.Numbers(1, List.Count(Tables)), each Number.ToText(_)),
  Source = Table.ExpandTables(#table(Cols, {Tables}))
in
Source
