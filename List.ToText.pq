/*
Create text representation of given List to use further in Power Query code
Usage: List_ToText({"abc","def","hgk"}) = {"abc","def","hgk"}
*/

(list1 as list) as text =>
 "{""" & Text.Combine(list1, """, """) & """}"
