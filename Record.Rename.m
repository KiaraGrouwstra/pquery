/*
//Rename a record using a given lambda (passed values k,v)
//Usage:
let
    Record.Rename = Load("Record.Rename"),
    Rec = [A=1, B=2]
in
    Record.Rename(Rec, (k,v) => k & Text.From(v))
//Result: [A1=1, B2=2]
*/

(Rec as record, Lambda as function) as record =>
let
    Keys = Record.FieldNames(Rec),
    Values = Record.FieldValues(Rec),
    Renamed = List.Transform(Keys, each Lambda(_, Record.Field(Rec, _))),
    Recorded = Record.FromList(Values, Renamed),
    Return = Recorded
in
    Return
