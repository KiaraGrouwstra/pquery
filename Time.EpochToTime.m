(epoch as nullable text ) =>
let
    res = if epoch = null 
     then null
    else
    let
     remove_word = Text.Replace(epoch, "PT", ""),
     remove_letterH = Text.Replace(remove_word, "H", ":"),
     remove_letterM = Text.Replace(remove_letterH, "M", ":"),
     remove_letterS = Text.Replace(remove_letterM, "S", "")
     in 
      remove_letterS
in
    res
