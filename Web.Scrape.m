/*
// Scrape a web page, raising an error with a curl command for debugging purposes in case the response is empty.
//Usage:
    Web.Scrape = Load("Web.Scrape"),
    Web.Scrape("http://google.com", [#"Referer"="http://google.com"])
//Result: a binary representation of the Google front-page
*/

let Web.Scrape = (url as text, optional options as record) =>

let
    Response = Web.Contents(url, options),
	Return = if Binary.Length(Response) = 0
        then error Error.Record("ScrapeFailed", Curl(url, options), null)
        else Response
in
    Return

in Web.Scrape

