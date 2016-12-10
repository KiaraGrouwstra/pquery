// Function that converts number from decimal to binary notation
//
// Usage:
// Number.ToBinaryString( 1026 )
// result: 10000000010

(num as number, optional string as nullable text) =>
    let
        input_string = if string = null then "" else string,

        reminder = Number.Mod( num, 2 ),
        resulting_string = Text.From( reminder ) & input_string,

        input = Number.IntegerDivide( num, 2 ),

        r = if input > 0 then
            @fNumberToBinaryString( input , resulting_string)
            else resulting_string
    in
        r
