/*
//Remove all uicode symbols from text
//Originally written by Chris Webb: https://cwebbbi.wordpress.com/2014/08/18/removing-punctuation-from-text-in-power-query/
//Usage:
    Table.ExpandAll = Load("Table.ExpandAll"),
    xml = Xml.Tables("<books><book><name>Book1</name><pages><page>1</page><page>2</page><page>3</page></pages></book><book><name>Book2</name><pages><page>1</page><page>2</page><page>3</page></pages></book></books>"),
    Table.ExpandAll(xml)	//, null, true
//Result: [an expanded version of the given table with nested records/tables]
*/
let (inputtext) =>
let
    //get a list of lists containing the numbers of Unicode punctuation characters
    numberlists = {{0..31},{33..47},{58..64},{91..96},{123..191}},
    //turn this into a single list
    combinedlist = List.Combine(numberlists),
    //get a list of all the punctuation characters that these numbers represent
    punctuationlist = List.Transform(combinedlist, each Character.FromNumber(_)),
    //some text to test this on
    //inputtext = "Hello! My name is Chris, and I'm hoping that this *cool* post will help you!",
    //the text with punctuation removed
    outputtext = Text.Remove(inputtext, punctuationlist)
in
    outputtext