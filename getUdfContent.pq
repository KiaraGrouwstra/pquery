(fnName as text) => let
    Path = LoadPath & (if Text.End(LoadPath, 1) <> "\" then "\" else ""),
    File = Path & Text.Replace(fnName, "_", ".") & ".pq",
    AltFile = Path & fnName & ".m",  //just in case...
    Source = Text.FromBinary(Binary.Buffer(
      try File.Contents(File)
      otherwise File.Contents(AltFile)
    ))
in
    Source
