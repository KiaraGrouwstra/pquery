(ListWithError as list) as list =>
/*  removes error values from list (without replacement) without "convert to table / remove rows"
    Author: Owen Auger https://nz.linkedin.com/in/owenauger http://owenaugerblog.wordpress.com/
    Source: http://community.powerbi.com/t5/Desktop/Removing-errors-from-list-not-column-in-Power-Query-M/m-p/78765
*/
let
    Source = List.Accumulate(
    List.Positions(ListWithError),
    {},
    (CleanListSoFar, CurrentPosition) =>
        CleanListSoFar &
        (if (try ListWithError{CurrentPosition})[HasError] 
         then {} 
         else {ListWithError{CurrentPosition}}
        )
    )
in
    Source
