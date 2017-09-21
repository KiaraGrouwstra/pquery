(DateValue as any) =>
let  
  FormattedDate = DateTime.ToText(DateTime.From(DateValue), "yyyy-MM-ddT00:00:00", "en-US")
in
  FormattedDate
