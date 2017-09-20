/*
  convert date from SAP ByDesign into normal date
  SAP JSON response shows date as "/Date(1357084800000)/"
  can be used with 
  Table.TransformColumns(Expand,{{"Posting Date", EpochToDate}})
*/

let EpochToDateTime = (epoch as nullable text ) =>
let
    res = if epoch = null 
     then null
    else
    let
     remove_word = Text.Replace(epoch, "Date", ""),
     remove_slash = Text.Replace(remove_word, "/", ""),
     remove_left_par = Text.Replace(remove_slash, "(", ""),
     remove_right_par = Text.Replace(remove_left_par, ")", ""),
     calc = #datetime(1970, 1, 1, 0, 0, 0) + #duration(0, 0, 0, Number.FromText(Text.Start(remove_right_par,Text.Length(remove_right_par)-3)))
    in 
      calc
in
    res
in 
    EpochToDateTime
