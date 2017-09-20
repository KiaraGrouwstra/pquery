/*
Maps a list using a lambda in such a way that all results are combined back into a single list.
//Usage:
let
    List.FlatMap = Load("List.FlatMap")
in
    List.FlatMap({1,2,3}, (_) => List.Numbers(1, _))
//Result: {1, 1, 2, 1, 2, 3}
*/

(lst as list, fn as function) => List.Combine(List.Transform(lst, fn))
