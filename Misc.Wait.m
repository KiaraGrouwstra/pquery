// This function is now obsolete due to the addition of Function.InvokeAfter(), see:
// https://cwebbbi.wordpress.com/2015/04/30/using-function-invokeafter-in-power-query/

/*
//Delay the given action for the specified number of seconds
//Usage:
    Misc.Wait = Load("Misc.Wait"),
    Misc.Wait(0.5, () => Web.Contents("www.bing.com"))
//Result: [whatever result of the given action, except 0.5 seconds slower]
*/

(seconds as number, action as function) =>
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
// this if ... then null never triggers, but its purpose is to make the function depend on the waiting loop finishing
else action()

