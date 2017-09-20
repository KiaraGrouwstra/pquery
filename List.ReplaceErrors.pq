/*
Replaces error values in given list with passed replacement value (or with null if replacement is omitted)
*/

(ListWithError as list, optional Replacement as any) as list =>
let
    Source = List.Transform(
        List.Positions(ListWithError), 
        each try ListWithError{_} otherwise Replacement)
in
    Source
