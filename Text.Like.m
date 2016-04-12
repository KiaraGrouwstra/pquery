/*
//Allows doing fuzzy string comparisons akin to SQL's LIKE
//Usage:
    Text.Like = Load("Text.Like"),
    Text.Like("the cat sat on the mat", "%cat%sat%mat%")
//Result: true
*/

//Originally written by Chris Webb: https://cwebbbi.wordpress.com/2014/05/27/implementing-a-basic-likewildcard-search-function-in-power-query/
(Phrase as text, Pattern as text) as logical =>
let
    //Split pattern up into a list using % as a delimiter
    PatternList = Text.Split(Pattern, "%"),
    //if the first character in the pattern is % then the first item in the list is an empty string
    StartsWithWc = (List.First(PatternList)=""),
    //if the last character in the pattern is % then the last item in the list is an empty string
    EndsWithWc = (List.Last(PatternList)=""),
    //if the first character is not % then we have to match the first string in the pattern with the opening characters of the phrase
    StartsTest = if (StartsWithWc=false) 
       then Text.StartsWith(Phrase, List.First(PatternList)) 
       else true,
    //if the last item is not % then we have to match the final string in the pattern with the final characters of the phrase
    EndsText = if (EndsWithWc=false) 
       then Text.EndsWith(Phrase, List.Last(PatternList)) 
       else true,
    //now we also need to check that each string in the pattern appears in the correct order in the phrase and to do this we need to declare a function PhraseFind
    PhraseFind = (Phrase as text, SearchString as list) =>
    let
     //does the first string in the pattern appear in the phrase?
     StringPos = Text.PositionOf(Phrase, SearchString{0}, Occurrence.First),
     PhraseFindOutput = 
		 if
		 //if string not find then return false 
		 (StringPos=-1) 
		 then false 
		 else if
		 //we have found the string in the pattern, and if this is the last string in the pattern, return true
		 List.Count(SearchString)=1
		 then true
		 else
		 //if it isn't the last string in the pattern test the next string in the pattern by removing the first string from the pattern list and all text up to and including the string we have found in the phrase
		 (true and
		 @PhraseFind(
		 Text.RemoveRange(Phrase, 0, StringPos + Text.Length(SearchString{0})),
		 List.RemoveRange(SearchString, 0, 1)))
     in
      PhraseFindOutput,
    //return true if we have passed all tests    
    Output = StartsTest and EndsText and PhraseFind(Phrase, PatternList) 
in
    Output
