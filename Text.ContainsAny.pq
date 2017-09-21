/*
//Check if a string contains any of the keywords from a given list
//Usage:
    Text.ContainsAny = Load("Text.ContainsAny"),
    Text.ContainsAny("the cat sat on the mat", {"cat", "apple"})
//Result: true
*/

(str as text, needles as list) as logical =>
let
	count = List.Count(needles)
in

List.AnyTrue(
	List.Generate(
		()=>[i=0],
		each [i] < count,
		each [i=[i]+1],
		each Text.Contains(str,needles{[i]})
	)
)

