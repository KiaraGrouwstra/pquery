/*
//Get a curl command string for a given url and options (as used in Web.Contents()) for debugging purposes.
//Usage:
    Web.Curl = Load("Web.Curl"),
    Web.Curl("http://item.taobao.com/item.htm", [Query=[id="16390081398"]])
//Result: 'curl "http://item.taobao.com/item.htm?id=16390081398" -v'
*/

(url as text, optional options as record) as text =>
let
    //url = "http://item.taobao.com/item.htm?id=16390081398",
    //options = [Query=null],

    query = options[Query],
    headers = options[Headers],
    qList = List.Transform(Record.FieldNames(query), each _ & "=" & Record.Field(query, _)),
    hList = List.Transform(Record.FieldNames(headers), each " -H """ & _ & ": " & Record.Field(headers, _) & """"),
    qJoined = try "?" & Text.Combine(qList, "&") otherwise "",
    hJoined = try Text.Combine(hList, "") otherwise "",
    Return = "curl """ & url & qJoined & """" & hJoined & " -v"
in
    Return

