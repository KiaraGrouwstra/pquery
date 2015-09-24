/*
Returns the number of occurrences of a substring (needle) within another string (haystack).
//Usage:
let
    Text.Count = Load("Text.Count")
in
    Text.Count("Abba", "b")
//Result: 2
*/

(Haystack as text, Needle as text) as number =>
List.Count(Text.Split(Haystack, Needle)) - 1
