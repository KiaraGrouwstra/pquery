/*
//Grabs the substring between the specified 'after' and 'before' strings
//Usage:
    Text.EachFromTo = Load("Text.EachFromTo"),
    Text.EachFromTo("a[bc][d]ef", "[", "]")
//Result: {"[bc]", "[d]"}
*/

let Text.EachFromTo = (Haystack as text, After as text, Before as text) =>
let
    CutAfter = Text.Split(Haystack, After),
	SkipFirst = List.Skip(CutAfter),
    CutEach = List.Transform(SkipFirst, each After & Text.Split(_, Before){0} & Before)
in 
    CutEach
in
    Text.EachFromTo

