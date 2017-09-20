/*
//Zip a list of lists so as to 'transpose' them -- as records if names are specified.
//Usage:
    List.Zip = Load("List.Zip"),
    List.Zip({{1,2,3},{"a","b","c"}}, {"num","let"})
//Result: {[num=1, let="a"],[num=2, let="b"],[num=3, let="c"]}
*/

(listOfLists as list, optional names as list) as list =>
let
	max = List.Max(List.Transform(listOfLists, each List.Count(_))),
	zipped = List.Skip(List.Generate(
        ()=>[
            i = -1,
			vals = {},
			combined = {}
        ],
        each [i] < max,
        each [
            i = [i] + 1,
            vals = List.Transform(listOfLists, each _{i}),
			combined = if names = null then vals else Record.FromList(vals, names)
        ],
        each [combined]
    )),
	tablized = Table.FromRecords(zipped) //Table.FromRows
in
	tablized

