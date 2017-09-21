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

(str as text, Replacements as list) as text => List.Accumulate(Replacements, str, (s, x) => Text.Replace(s, x{0}, x{1}))
