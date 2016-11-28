() =>
	let
		start = Date.StartOfMonth(Date.AddMonths(Date.From(DateTime.FixedLocalNow()), -12)),
		end = Date.AddDays(Date.StartOfMonth(Date.From(DateTime.FixedLocalNow())), -1),
		result = List.Dates(start, Duration.Days(end - start) + 1, #duration(1,0,0,0))
	in 
		result
