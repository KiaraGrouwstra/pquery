// Function that converts number from decimal to binary notation
//
// Usage:
// Number.Dec2Bin( 1026 )
// result: 10000000010
// Same as Excel funciton DEC2BIN
// https://support.office.com/en-us/article/DEC2BIN-function-0f63dd0e-5d1a-42d8-b511-5bf5c6d43838
//

(num as number, optional string as nullable text) =>
    let
        input_string = if string = null then "" else string,

        reminder = Number.Mod( num, 2 ),
        resulting_string = Text.From( reminder ) & input_string,

        input = Number.IntegerDivide( num, 2 ),

        r = if input > 0 then
            @Number_Dec2Bin( input , resulting_string)
            else resulting_string
    in
        r
