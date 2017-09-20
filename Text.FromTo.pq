/*
//Grabs the first substring from the specified 'From' up to the 'UpTo' string
//Usage:
    Text.FromTo = Load("Text.FromTo"),
    Text.FromTo("abcdef", "bc", "f")
//Result: "bcdef"
*/

(Haystack as text, From as text, UpTo as text) as text =>
let
    CutAfter = Text.Split(Haystack, From),
    CutBefore = Text.Split(CutAfter{1}, UpTo),
    Needle = if List.Count(CutAfter) > 1
       then (if List.Count(CutBefore) > 1 then From & CutBefore{0} & UpTo else Error.Record("FindTextFailed","The text did not contain the keyword " & UpTo, Haystack))
       else error Error.Record("FindTextFailed","The text did not contain the keyword " & From, Haystack)
in Needle

