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

(str as text, Replacements as list) as text =>
let
	count = List.Count(Replacements)
in

List.Last(
	List.Generate(
		()=>[i=0, s=str],
		each [i] <= count,
		each [
			s=Text.Replace([s],Replacements{[i]}{0},Replacements{[i]}{1}),
			i=[i]+1
		],
		each [s]
	)
)

