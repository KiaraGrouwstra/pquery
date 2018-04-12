// About// Sorts mixed list of text and numbers in a numerical order for numbers and alphanumeric for text 
// Arguments// "txt"= Text value to sort 
// Source// Author: Bill Szysz in https://social.technet.microsoft.com/Forums/en-US/aed476c6-0daa-4aa2-b763-993195d4d0eb/how-to-sort-in-cell-values-with-comma-seperated-using-power-query?forum=powerquery 
// Imp// Suggested improvement: Integrate option to choose order direction (ascending, descending) by function parameters 

 
(txt as text) as text =>
let 
    SplitTrim = List.Transform(Text.Split(txt, ","), each Text.Trim(_)), 
    Transform = List.Transform(SplitTrim, each try Number.From(_) otherwise _), 
    LstSort = List.Sort(Transform, 0), 
    Transform2 = List.Transform(LstSort, each Text.From(_)), 
    CombineText = Text.Combine(Transform2, ", ")  	 
in 
    CombineText
