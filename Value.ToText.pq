/*
//Returns a string representation of a value, which works even on containers, unlike the built-in Text.From()
//Usage:
    Value.ToText = Load("Value.ToText"),
    Value.ToText({1,2,3})
//Result: "{1, 2, 3}"
*/

let Value.ToText =
(Val as any, optional RecursTypes as logical) as text =>
let
    Record.TransformJoin = Load("Record.TransformJoin"),
    Type.ToText = Load("Type.ToText"),
    RecursTypes = if (RecursTypes<>null) then RecursTypes else false,
    Tried = (try Val),
    Value = if Tried[HasError] then Tried[Error] else Tried[Value],
/*
    DurationVals = {Duration.Days, Duration.Hours, Duration.Minutes, Duration.Seconds},
    DateVals = {Date.Year, Date.Month, Date.Day},
    TimeVals = {Time.Hour, Time.Minute, Time.Second},
    ZoneVals = {DateTimeZone.ZoneHours, DateTimeZone.ZoneMinutes},
    GetNumbers = (vals as list, obj as any) as text => Text.Combine(List.Transform(vals, each Number.ToText(Function.Invoke(_, {obj}))), ","),
*/
    CaseValues = {
    //{ (x)=> (try x)[HasError], "error " & @Value.ToText((try Value)[Error], RecursTypes) },
    { (x)=> Value.Is(x, type type), Type.ToText(Value, RecursTypes) },
    { (x)=> Value.Is(x, type function),
        let
            Type = Value.Type(Value),
            Params = Type.FunctionParameters(Type),
            Reqd = Type.FunctionRequiredParameters(Type),
            Ret = Type.FunctionReturn(Type)
        in
        "function (" &
        Record.TransformJoin(Params, (k,v) =>
            (if List.PositionOf(Record.FieldNames(Params), k) >= Reqd then "optional " else "") &
            k & " as " & @Value.ToText(v, RecursTypes)
        )
        & ") as " & @Value.ToText(Ret, RecursTypes)
    },
    { (x)=> Value.Is(x, type table), "#table(" & @Value.ToText(Table.ColumnNames(Value), RecursTypes) & ", " & @Value.ToText(Table.ToRows(Value), RecursTypes) & ")"},
    { (x)=> Value.Is(x, type record), "[" &
        Record.TransformJoin(Value, (k,v) => k & "=" & @Value.ToText(v, RecursTypes))
    & "]" },
    { (x)=> Value.Is(x, type list), "{" & Text.Combine(List.Transform(Value, each @Value.ToText(_, RecursTypes)), ", ") & "}" },
    { (x)=> x = null, "null" },
/*
    { (x)=> Value.Is(x, type text), """" & Value & """" },
    { (x)=> Value.Is(x, type binary), "#binary(""" & Binary.ToText(Value) & """)" },
    { (x)=> Value.Is(x, type date), "#date(" & GetNumbers(DateVals, Value) & ")" },    //alt: Date.ToText(Value)
    { (x)=> Value.Is(x, type time), "#time(" & GetNumbers(TimeVals, Value) & ")" },    //alt: Time.ToText(Value)
    { (x)=> Value.Is(x, type datetime),
        let
            Date = DateTime.Date(Value),
            Time = DateTime.Time(Value)
        in
            "#datetime(" & GetNumbers(DateVals, Date) & ", " & GetNumbers(TimeVals, Time) & ")"
    },    //alt: DateTime.ToText(Value)
    { (x)=> Value.Is(x, type datetimezone),
        let
            DateTime = DateTimeZone.RemoveZone(Value),
            Date = DateTime.Date(DateTime),
            Time = DateTime.Time(DateTime)
        in
            "#datetimezone(" & GetNumbers(DateVals, Date) & ", " & GetNumbers(TimeVals, Time) & ", " & GetNumbers(ZoneVals, Value) & ")"
    },    //alt: DateTimeZone.ToText(Value)
    { (x)=> Value.Is(x, type duration), "#duration(" & GetNumbers(DurationVals, Value) & ")" },    //alt: Duration.ToText(Value)
//    { (x)=> Value.Is(x, type logical), Logical.ToText(Value) },
//    { (x)=> Value.Is(x, type number), Number.ToText(Value) },
    { (x)=> true, Text.From(Value) }
*/
    { (x)=> true, Expression.Constant(Value) }
    },
    Return = List.First(List.Select(CaseValues, each _{0}(Value))){1}
in Return
in Value.ToText
