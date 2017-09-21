/*
//Grabs the substring between the specified 'after' and 'before' strings
//Usage:
    Text.EachBetween = Load("Text.EachBetween"),
    Text.EachBetween("a[bc][d]ef", "[", "]")
//Result: {"bc", "d"}
*/

(Haystack as text, After as text, Before as text) as list =>
let
    CutAfter = Text.Split(Haystack, After),
	SkipFirst = List.Skip(CutAfter),
    CutEach = List.Transform(SkipFirst, each Text.Split(_, Before){0})
in 
    CutEach

