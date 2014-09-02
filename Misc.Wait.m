/*
//Delay the given action for the specified number of seconds
//Usage:
    Misc.Wait = Load("Misc.Wait"),
    Misc.Wait(0.5, () => Web.Contents("www.bing.com"))
//Result: [whatever result of the given action, except 0.5 seconds slower]
*/

let
    Misc.Wait = (seconds as number, action as function) =>

    if (
        List.Count(
            List.Generate(
				() => DateTimeZone.LocalNow() + #duration(0,0,0,seconds),
				(x) => DateTimeZone.LocalNow() < x,
				(x) => x
			)
        ) = 0
	)
	then null
	else action()

in
    Misc.Wait

