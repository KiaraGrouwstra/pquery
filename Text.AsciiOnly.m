//Filters out all non-ascii characters from a string

(s as text) as text =>
let
	Listified = Text.ToList(s),
	Numbered = List.Transform(Listified, each Character.ToNumber(_)),
	Filtered = List.Select(Numbered, each _ <= 255),
	Stringified = List.Transform(Filtered, each Character.FromNumber(_)),
	Joined = Text.Combine(Stringified, ""),
	Return = Joined
in
	Return
