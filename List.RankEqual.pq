/*
//Ranks an input value in a series (ascendingly or descendingly). Does not filter out duplicates.
//Usage:
    List.RankEqual = Load("List.RankEqual"),
    List.RankEqual("B",{"A","A","B","C"})
//Result: 3
*/

//Originally written by Colin Banfield: http://social.technet.microsoft.com/Forums/en-US/973e9381-ff46-4756-a071-88bb4c2105e4/pushing-more-calcs-to-power-query-replacing-dax-rankx

(inputValue as any, inputSeries as list, optional orderDescending as nullable logical) as number => 
let
	order = if orderDescending or orderDescending = null then Order.Descending else Order.Ascending,
    SortedSeries = List.Sort(inputSeries, order),
    RankEqual = List.PositionOf(SortedSeries,inputValue)+1
in
    RankEqual
