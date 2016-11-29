/*
//Transform a list of strings to a record using a given lambda (passed values k)
//The built-in Record.FromList only takes static lists...
//Usage:
let
    List.ToRecord = Load("List.ToRecord"),
    list = {"a","b"}
in
    List.ToRecord(list, (k) => Text.Upper(k))
//Result: [a="A", b="B"]
*/

(List as list, Lambda as function) as record =>
let
    Transformed = List.Transform(List, Lambda)	//each Lambda(_)
in
    Record.FromList(Transformed, List)
