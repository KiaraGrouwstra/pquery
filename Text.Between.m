/*
//Grabs the substring between the specified 'after' and 'before' strings
//Usage:
    Text.Between = Load("Text.Between"),
    Text.Between("abcdef", "bc", "f")
//Result: "de"
*/

let Text.Between = (Haystack as text, After as text, Before as text) =>
let
    CutAfter = Text.Split(Haystack, After){1},
    Needle = Text.Split(CutAfter, Before){0}
in 
    Needle
in
    Text.Between

