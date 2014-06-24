/*
//Do multiple text replacements in one function call, passing the replacements as a list of lists
//Usage:
    Text.ReplaceAll = Load("Text.ReplaceAll"),
    Text.ReplaceAll("(test)", {
	    {"(", "["},
	    {")", "]"}
	})
//Result: "[test]"
*/

let
    Text.ReplaceAll = (str as text, Replacements as list) =>
let
    NextReplace = Replacements{0},
    Cleaned = Text.Replace(str,NextReplace{0}, NextReplace{1}),
    ReplLeft = List.Skip(Replacements),
    Text.ReplaceAll = Load("Text.ReplaceAll"),
    Return = if List.IsEmpty(ReplLeft)
		then Cleaned
		else Text.ReplaceAll(Cleaned, ReplLeft)
in
    Return

in Text.ReplaceAll

