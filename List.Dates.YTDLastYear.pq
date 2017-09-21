() =>
	let
		start = Date.StartOfYear(Date.AddYears(Date.From(DateTime.FixedLocalNow()), -1)),
		end = Date.AddYears(Date.From(DateTime.FixedLocalNow()), -1),
		result = List.Dates(start, Duration.Days(end - start) + 1, #duration(1,0,0,0))
	in 
		result
