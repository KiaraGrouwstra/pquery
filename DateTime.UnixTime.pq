/*
  Convert unix timestamp into Power Query datetime formart
  Usage: DateTime_UnixTime(1526800525) = 20.05.2018 7:15:25
*/

(unixtime as number) as datetime => #datetime(1970, 01 , 01, 0, 0, 0) + #duration(0,0,0,unixtime)
