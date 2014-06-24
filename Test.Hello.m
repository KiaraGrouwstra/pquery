/*
//Demonstrates external functions can also call other external functions
//Usage:
    Test.Hello = Load("Test.Hello"),
    Test.Hello()
//Result: "Hello"
*/

let Test.Hello = () =>
let
    Test.Print = Load("Test.Print")
in
    Test.Print("Hello")
in
    Test.Hello

