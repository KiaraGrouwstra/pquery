/*
//Returns a simple string representation of a type, which allows easy filtering
//Usage:
    Type.ToText = Load("Type.ToText"),
    Type.ToText(type list)
//Result: "list"
*/

let Type.ToText =
(Type as any, optional Recurs as logical) as text =>
let
    Record.TransformJoin = Load("Record.TransformJoin"),
    Recurs = if (Recurs<>null) then Recurs else false,

    CaseValues = {
    { (x)=> (try x)[HasError], "error" },
    { (x)=> Type.Is(x, type type), "type"},    //if Recurs then  else 
    { (x)=> Type.Is(x, type function), "function"},
    { (x)=> Type.Is(x, type table), if Recurs then "table " & @Type.ToText(Type.TableRow(NonNull), Recurs) else "table"},
    { (x)=> Type.Is(x, type record), if Recurs then
        let
            Record = Type.RecordFields(NonNull)
        in "[" & Record.TransformJoin(Record, (k,v) =>
            (if v[Optional] then "optional " else "") & Expression.Identifier(k) & " = " & @Type.ToText(v[Type], Recurs)
        ) & "]"
    else "record"},
    { (x)=> Type.Is(x, type list), if Recurs then "{" & @Type.ToText(Type.ListItem(NonNull), Recurs) & "}" else "list"},
    { (x)=> Type.Is(x, type binary), "binary"},
    { (x)=> Type.Is(x, type logical), "logical"},
    { (x)=> Type.Is(x, type number), "number"},
    { (x)=> Type.Is(x, type text), "text"},
    { (x)=> Type.Is(x, type date), "date"},
    { (x)=> Type.Is(x, type time), "time"},
    { (x)=> Type.Is(x, type datetime), "datetime"},
    { (x)=> Type.Is(x, type datetimezone), "datetimezone"},
    { (x)=> Type.Is(x, type duration), "duration"},
    { (x)=> Type.Is(type anynonnull, x), "anynonnull"},
    { (x)=> Type.Is(type null, x), "null"},
    { (x)=> Type.Is(None.Type, x), "none"},
//    { (x)=> Type.Is(type any, x), "any"},
    { (x)=> true, "?"}
    },
    NonNull = Type.NonNullable(Type),
    Return = if Type.Is(type any, Type) then "any"
    else (if Type.IsNullable(Type) then "nullable " else "")
    & List.First(List.Select(CaseValues, each _{0}(NonNull))){1}
in Return
in Type.ToText
