1 //About// Sorts mixed list of text and numbers in a numerical order for numbers and alphanumeric for text 
2 //Arguments// "txt"= Text value to sort 
3 //Source// Author: Bill Szysz in https://social.technet.microsoft.com/Forums/en-US/aed476c6-0daa-4aa2-b763-993195d4d0eb/how-to-sort-in-cell-values-with-comma-seperated-using-power-query?forum=powerquery 
4 //Imp// Suggested improvement: Integrate option to choose order direction (ascending, descending) by function parameters 
5 
 
6 (txt as text) as text => 
7 	let 
8 	   SplitTrim = List.Transform(Text.Split(txt, ","), each Text.Trim(_)), 
9 	   Transform = List.Transform(SplitTrim, each try Number.From(_) otherwise _), 
10        LstSort = List.Sort(Transform, 0), 
11 	   Transform2 = List.Transform(LstSort, each Text.From(_)), 
12 	   CombineText = Text.Combine(Transform2, ", ") 
13 	 in 
14 	   CombineText 
