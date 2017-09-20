/*
//Shorthand for returning a string representation (using a given lambda) of a record
//Usage:
    Record.TransformJoin = Load("Record.TransformJoin"),
    Rec = [A=1, B=2],
    Record.TransformJoin(Rec, each _ & "=" & Text.From(Record.Field(Rec, _)))
//Result: "A=1, B=2"
*/

(Rec as record, Lambda as function, optional Delimiter as text) as text =>
let
    Delimiter = if (Delimiter<>null) then Delimiter else ", ",

    Keys = Record.FieldNames(Rec),
    Transformed = List.Transform(Keys, each Lambda(_, Record.Field(Rec,_))),
    Combined = Text.Combine(Transformed, Delimiter),

    Return = Combined
in
    Return
