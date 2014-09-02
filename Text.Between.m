/*
//Grabs the substring between the specified 'after' and 'before' strings
//Usage:
    Text.Between = Load("Text.Between"),
    Text.Between("abcdef", "bc", "f")
//Result: "de"
*/

let Text.Between = (Haystack as text, After as text, Before as text, optional Backward as logical) =>
let
    CutAfter = if Backward = true then Text.Split(Haystack, Before){0} else Text.Split(Haystack, After){1},
    Needle = if Backward = true then List.Last(Text.Split(CutAfter, After)) else Text.Split(CutAfter, Before){0}
in Needle
in Text.Between

