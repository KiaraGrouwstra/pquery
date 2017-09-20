// creates empty table with headers provided in string with delimiters

(String as text, Separator as text) => 
  Table.PromoteHeaders( Table.Transpose( Table.FromList( Text.Split( String, Separator ) ) ) )
