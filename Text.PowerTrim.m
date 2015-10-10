/*
  Function removes double presents of specified characters.
  By default remove double spaces and leading + ending spaces.
  Like TRIM function in Excel

*/

(text as text, optional char_to_trim as text) =>
	 let
		 char = if char_to_trim = null then " " else char_to_trim,
		 split = Text.Split(text, char),
		 removeblanks = List.Select(split, each _ <> ""),
		 result=Text.Combine(removeblanks, char)
	 in
 result
