/*
//Returns a simple string representation of a value's type, which allows easy filtering, unlike the built-in Value.Type()
//Usage:
let
    Value.TypeToText = Load("Value.TypeToText")
in
    Value.TypeToText({1,2,3})
//Result: "list"
*/

(Value as any, optional Recurs as logical) as text =>
let
    Recurs = if (Recurs<>null) then Recurs else false,
    Type.ToText = Load("Type.ToText"),

    Type = Value.Type(Value),
    ToText = if Value.Is(Value, type type) and Recurs then
        "type " & Type.ToText(Value, Recurs)
    else
        Type.ToText(Type, Recurs),
/*
    CaseValues = {
    { (x)=> (try x)[HasError], "error" },
    { (x)=> x = null, "null" },
    { (x)=> Value.Is(x, type type), "type"},
    { (x)=> Value.Is(x, type function), "function"},
    { (x)=> Value.Is(x, type table), "table"},
    { (x)=> Value.Is(x, type record), "record"},
    { (x)=> Value.Is(x, type list), "list"},
    { (x)=> Value.Is(x, type binary), "binary"},
    { (x)=> Value.Is(x, type logical), "logical"},
    { (x)=> Value.Is(x, type number), "number"},
    { (x)=> Value.Is(x, type text), "text"},
    { (x)=> Value.Is(x, type date), "date"},
    { (x)=> Value.Is(x, type time), "time"},
    { (x)=> Value.Is(x, type datetime), "datetime"},
    { (x)=> Value.Is(x, type datetimezone), "datetimezone"},
    { (x)=> Value.Is(x, type duration), "duration"},
    { (x)=> true, "?"}
    },
    Return = List.First(List.Select(CaseValues, each _{0}(Value))){1}
*/
    Return = ToText
in Return

