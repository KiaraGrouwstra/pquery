(DateTimeValue as any) =>
  FormattedDate = DateTime.ToText(DateTime.From(DateTimeValue), "yyyy-MM-ddThh:mm:ss", "en-US")
