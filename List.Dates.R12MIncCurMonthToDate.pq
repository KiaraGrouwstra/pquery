() =>
	let
		start = Date.StartOfMonth(Date.AddMonths(Date.From(DateTime.FixedLocalNow()), -11)),
		end = Date.From(DateTime.FixedLocalNow()),
		result = List.Dates(start, Duration.Days(end - start) + 1, #duration(1,0,0,0))
	in 
		result
