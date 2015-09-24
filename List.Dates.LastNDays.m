(N as number) => 
	List.Dates(Date.From(Date.AddDays(Date.From(DateTime.FixedLocalNow()), -N)), N, #duration(1,0,0,0))
