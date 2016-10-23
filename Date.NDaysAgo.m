/*
	return date of N days ago from Today
	usage: 
	let
		Date.NDaysAgo = Load("Date.NDaysAgo")
	in
		Date.NDaysAgo(3)
	//Result depends on Today
*/

(N as number) => 
	Date.AddDays(DateTime.FixedLocalNow(), -N)
