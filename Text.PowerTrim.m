/*
  Function removes double presents of specified characters.
  By default remove double spaces and leading + ending spaces.
  Like TRIM function in Excel
  
  Original is taked from Ken Puls's blog
  http://www.excelguru.ca/blog/2015/10/08/clean-whitespace-in-powerquery/
*/

(text as text, optional char_to_trim as text) =>
	 let
		 char = if char_to_trim = null then " " else char_to_trim,
		 split = Text.Split(text, char),
		 removeblanks = List.Select(split, each _ <> ""),
		 result=Text.Combine(removeblanks, char)
	 in
 result
