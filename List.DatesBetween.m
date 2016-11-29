// List_DatesBetween
// List_DatesBetween is an alternative for List.Dates function. It takes only two dates as arguments and creates a list of dates between given two dates. 
// Usage: List_DatesBetween(11/17/2016, 12/19/2016)

(dateStart as date, dateFinish as date) =>

let

    countOfDays = Number.From(dateFinish - dateStart),
    output = if countOfDays > 0 
                then List.Dates(dateStart, countOfDays+1, #duration(1,0,0,0))
                else "Error! Your inputs are incorrect. Check the inputs." 
in
    output
