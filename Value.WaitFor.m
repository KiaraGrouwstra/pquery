//author: Curt Hagenlocher
//https://gist.github.com/CurtHagenlocher/68ac18caa0a17667c805

(producer as function, interval as function, optional count as number) as any =>
let
	list = List.Generate(
		//start: first try, no result
		() => {0, null},
		//condition: stop if we have the result (try count null'd) or we've exceeded the max tries
		(state) => state{0} <> null and (count = null or state{0} < count),
		//next: stop try tally if we have our result, otherwise check again and tally a try
		(state) => if state{1} <> null
			then {null, state{1}}
			else {1 + state{0}, Function.InvokeAfter(() => producer(state{0}), interval(state{0}))},
		//transformer: only return the result, not try tally
		(state) => state{1})
in
	List.Last(list)
