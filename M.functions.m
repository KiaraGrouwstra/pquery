let
    Type.ToText = Load("Type.ToText"),
    Value.ToText = Load("Value.ToText"),
    Text.Count = Load("Text.Count"),
    Source = M_library,
    Functions = Table.SelectRows(Source, each Value.Is([Value], type function)),
    AddFType = Table.AddColumn(Functions, "FType", each Value.Type([Value])),
    AddReturn = Table.AddColumn(AddFType, "Returns", each Type.FunctionReturn([FType])),
    AddRetTxt = Table.AddColumn(AddReturn, "RetText", each Type.ToText([Returns])),
    AddRetRec = Table.AddColumn(AddRetTxt, "RetRecursive", each Type.ToText([Returns], true)),
    AddRetNull = Table.AddColumn(AddRetRec, "RetNullable", each Type.IsNullable([Returns])),
    AddRetType = Table.AddColumn(AddRetNull, "RetType", each let Type = Type.ToText(Type.NonNullable([Returns])) in if Type = "anynonnull" and [RetNullable] then "any" else Type),
    AddParams = Table.AddColumn(AddRetType, "Parameters", each Type.FunctionParameters([FType])),
    AddNumPars = Table.AddColumn(AddParams, "NumParams", each Record.FieldCount([Parameters])),
    AddReqd = Table.AddColumn(AddNumPars, "Required", each Type.FunctionRequiredParameters([FType])),
    AddSig = Table.AddColumn(AddReqd, "Signature", each Value.ToText([Value])),
    AddSigRec = Table.AddColumn(AddSig, "SigRecursive", each [Name] & " => " & Value.ToText([Value], true)),
    AddTally = Table.AddColumn(AddSigRec, "Times Used", each Text.Count(Text_Queries, [Name])),
    GoodCols = Table.RemoveColumns(AddTally, {"Type", "TypeRecurs"}),
    Return = GoodCols
in
    Return

