/*
//Join 3+ tables at once
//Usage:
    Table.JoinMany = Load("Table.JoinMany"),
	TableA = #table({"country","language"},{{"US", "English"},{"Netherlands", "Dutch"},{"Japan", "Japanese"}}),
	TableB = #table({"country","continent"},{{"US", "Americas"},{"Netherlands", "Europe"},{"Japan", "Asia"}}),
	TableC = #table({"country","population"},{{"US", 316148990},{"Netherlands", 16770000},{"Japan", 127600000}}),
    Table.JoinMany({TableA,TableB,TableC},"country")	//,{"lang","cont","pop"}
//Result: #table({"country","language","continent","population"},{{"US", "English", "Americas", 316148990},{"Netherlands", "Dutch", "Europe", 16770000},{"Japan", "Japanese", "Asia", 127600000}})
*/

(
	tables as list,							//the tables you wish to join
	key as any,								//the key(s) to join them by, either as single string or as a list with 1 key per table
	//names as list,						//names of the tables used for prefixing identically named columns
	optional joinKind as nullable number	//how to join the tables: JoinKind.Inner (default), JoinKind.LeftOuter, JoinKind.RightOuter, JoinKind.FullOuter, JoinKind.LeftAnti, JoinKind.RightAnti
) as table =>
let
	joinKind = if (joinKind=null) then JoinKind.Inner else joinKind,
	count = List.Count(tables),
	Combined = List.Last(
		List.Generate(
			()=>[
				i = 1,
				Tbl = tables{0}
			],
			each [i]<=count,
			each let
				i1 = [i]-1,		//index
				i2 = [i],
				n1 = "JoinCol1",	//names{i1},	//table name for prefixing
				n2 = "JoinCol2",	//names{i2},
				k1 = if key is list then key{i1} else key,	//column key
				k2 = if key is list then key{i2} else key,
				key1 = n1 & "." & k1,	//qualified key (because PQ Join doesn't allow joining tables with identical column names)
				key2 = n2 & "." & k2,
				t1 = [Tbl],
				t2 = tables{i2},
				tab1 = Table.RenameColumns(t1,{k1,key1}),
				tab2 = Table.RenameColumns(t2,{k2,key2}),
				Merged = Table.Join(tab1, key1, tab2, key2, joinKind),
				AddCol = Table.AddColumn(Merged, k2, each let
						r1 = Record.Field(_,key1),
						r2 = Record.Field(_,key2)
					in if r1 = null then r2 else r1),
				Removed = Table.RemoveColumns(AddCol, {key1, key2})
			in [
				Tbl = Removed,
				i = [i]+1
			],
			each [Tbl]
		)
	),
	KeyColName = if key is list then key{count} else key,
	MergedColNames = Table.ColumnNames(Combined),
	KeyToFront = List.Combine({{KeyColName},List.RemoveItems(MergedColNames,{KeyColName})}),
	Reordered = Table.ReorderColumns(Combined, KeyToFront)

in
	Reordered
