/*
//Transform a record using a given lambda (passed values k,v)
//Usage:
let
    Record.Transform = Load("Record.Transform"),
    // alt: F[Record.Transform]
    Rec = [A=1, B=2]
in
    Record.Transform(Rec, (k,v) => k & Text.From(v))
//Result: [A="A1", B="B2"]
*/

(Rec as record, Lambda as function) as record =>
let
    Keys = Record.FieldNames(Rec),
    Transformed = List.Transform(Keys, each Lambda(_, Record.Field(Rec, _))),
    Recorded = Record.FromList(Transformed, Keys),
    Return = Recorded
in
    Return
