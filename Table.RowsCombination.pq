/*
//Returns the Cartesian product of rows of list of tables having same structure
// Usage:
	Table.RowsCombination( {Table1, Table2} )
	
//Result: all possible combination of rows from Table1 and Table2
// How it was created:
// https://bondarenkoivan.wordpress.com/2016/09/20/combination-of-rows-of-tables-list-in-power-query/
*/

(tables as list)=>
let
	tableslist = List.Buffer( tables ),
	list_as_numbers = List.Buffer( List.Transform( tableslist, each { 1 .. Table.RowCount(_) } ) ),

// Tycho's function
// https://github.com/tycho01/pquery/blob/master/List.CrossJoin.m
	
	list_crossjoin = (A as list, B as list) as table =>
		let
			firstList = List.RemoveNulls(A),
			secondList = List.RemoveNulls(B),
			firstLength = List.Count(firstList),
			secondLength = List.Count(secondList),
			resultFirstList = List.Generate( () => 0, 
		            each _ < firstLength * secondLength, 
		            each _ + 1, 
		            each firstList{ Number.IntegerDivide(_, secondLength) }),

			resultSecondList = List.Repeat( secondList, firstLength),	
			list_to_table = Table.FromColumns( {resultFirstList, resultSecondList} ),
		// my adjustment - merge and leave only merged column
			add_merged = Table.AddColumn(list_to_table, "Merged", each Text.Combine({Text.From([Column1]), Text.From([Column2])}, ""), type text),	
			remove_other = Table.SelectColumns( add_merged,{"Merged"})
		in
			remove_other,

// loop through list of numbers (each element is qty of table rows)
	generator = List.Last( List.Generate(
		() => [i=0, L=list_as_numbers{0}], // initial list
		each [i] <= List.Count( tableslist )-1,
		each [i=[i]+1,
			L = Table.Column( list_crossjoin( [L], list_as_numbers{[i]+1} ), "Merged") ],
		each [L] ) ),

// function that collects corresponding records (rows) from initial tables - loop through combination of indices
	get_tables_rows = (combination as text) => List.Last( List.Generate(
		()=> [i=0, L={}],
		each [i] <= List.Count( tableslist ),
		each [i=[i]+1,
			L = List.Combine( { [L], { tableslist{ [i] }{ Number.From( Text.Range( combination, [i], 1) )-1 } } } ) ],
		each [L] ) ),

	resulting_list = List.Transform( generator, each Table.FromRecords( get_tables_rows(_) ) ),
	list_to_table = Table.FromList(resulting_list, Splitter.SplitByNothing(), null, null, ExtraValues.Error),	
	result = Table.ExpandTableColumn( list_to_table, "Column1", Table.ColumnNames( tableslist{0} ), Table.ColumnNames( tableslist{0} ) )	
in
	result
