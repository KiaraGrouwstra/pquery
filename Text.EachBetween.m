/*
//Grabs the substring between the specified 'after' and 'before' strings
//Usage:
    Text.EachBetween = Load("Text.EachBetween"),
    Text.EachBetween("a[bc][d]ef", "[", "]")
//Result: {"bc", "d"}
*/

let Text.EachBetween = (Haystack as text, After as text, Before as text) =>
let
    CutAfter = Text.Split(Haystack, After),
	SkipFirst = List.Skip(CutAfter),
    CutEach = List.Transform(SkipFirst, each Text.Split(_, Before){0})
in 
    CutEach
in
    Text.EachBetween

