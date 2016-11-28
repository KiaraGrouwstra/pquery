(N as number) => 
	List.Dates(Date.AddDays(Date.From(DateTime.FixedLocalNow()), -N), N, #duration(1,0,0,0))
