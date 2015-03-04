/*
// Profiles the time taken to execute a function for the given parameters
//Usage:
    Text.Between = Load("Text.Between"),
    Function.Profile = Load("Function.Profile"),
    Function.Profile(Text.Between, {"abcdef", "bc", "f"})
//Result: 00:00:00
*/

let Function.Profile = (fn as function, params as list) =>

let
    TimeBefore = DateTime.LocalNow(),
	evaluated = Function.Invoke(fn, params),
    TimeAfter = (try evaluated as none otherwise DateTime.LocalNow()),
    TimeTaken = TimeAfter - TimeBefore
in
    TimeTaken

in Function.Profile

