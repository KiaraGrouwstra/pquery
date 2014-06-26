/*
//Returns the Cartesian product (i.e. crossjoin) of two arguments (can be lists or tables).
//Usage:
    List.CrossJoin = Load("List.CrossJoin"),
    List.CrossJoin({"A","B"},{1..3})
//Result: #table({"A","B"},{{"A",1},{"A",2},{"A",3},{"B",1},{"B",2},{"B",3}})
*/

let List.CrossJoin = (A as list, B as list) =>

let
	firstList = List.RemoveNulls(A),
	secondList = List.RemoveNulls(B),
	firstLength = List.Count(firstList),
	secondLength = List.Count(secondList),
	resultFirstList = List.Generate( () => 0, each _ < firstLength * secondLength, each _ + 1, each firstList{ Number.IntegerDivide(_, secondLength) }),
	resultSecondList = List.Repeat( secondList, firstLength)
in
	Table.FromColumns({resultFirstList, resultSecondList})

in List.CrossJoin

