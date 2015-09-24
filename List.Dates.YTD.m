() =>
	let
		start = Date.StartOfYear(Date.From(DateTime.FixedLocalNow())),
		end = Date.From(DateTime.FixedLocalNow()),
		result = List.Dates(start, Duration.Days(end - start) + 1, #duration(1,0,0,0))
	in 
		result
