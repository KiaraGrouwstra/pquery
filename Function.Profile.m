/*
// Profiles the time taken to execute a function for the given parameters
//Usage:
    Text.Between = Load("Text.Between"),
    Function.Profile = Load("Function.Profile"),
    Function.Profile(Text.Between, {"abcdef", "bc", "f"})
//Result: "de" meta 00:00:00
*/

(fn as function, params as list) as datetime =>
let
    TimeBefore = DateTime.LocalNow(),
	evaluated = Function.Invoke(fn, params),
    TimeAfter = (try evaluated as none otherwise DateTime.LocalNow()),
// ^ always evaluates to otherwise, just using the expression as a dummy to force getting the time only after evaluation has finished
    TimeTaken = TimeAfter - TimeBefore
in
    evaluated meta [taken=TimeTaken]
