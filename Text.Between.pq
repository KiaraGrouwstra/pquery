/*
//Grabs the substring between the specified 'after' and 'before' strings
//Usage:
    Text.Between = Load("Text.Between"),
    Text.Between("abcdef", "bc", "f")
//Result: "de"
*/

(Haystack as text, After as text, Before as text) as text =>
let
    CutAfter = Text.Split(Haystack, After),
    CutBefore = Text.Split(CutAfter{1}, Before),
    Needle = if List.Count(CutAfter) > 1
       then (if List.Count(CutBefore) > 1 then CutBefore{0} else Error.Record("FindTextFailed","The text did not contain the keyword " & Before, Haystack))
       else error Error.Record("FindTextFailed","The text did not contain the keyword " & After, Haystack)
in Needle

