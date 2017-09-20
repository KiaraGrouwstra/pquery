// last N years and Current year
(N as number) =>
	let
		start = Date.StartOfYear(Date.AddYears(Date.From(DateTime.FixedLocalNow()), -N)),
		end = Date.EndOfYear(Date.From(DateTime.FixedLocalNow())),
		result = List.Dates(start, Duration.Days(end - start) + 1, #duration(1,0,0,0))
	in 
		result
