pquery
======

This is a collection of functions written in the M language for use in Microsoft Excel's [Power Query plugin](http://office.microsoft.com/en-us/excel/download-microsoft-power-query-for-excel-FX104018616.aspx).

Rather than manually adding the functions to different Excel workbooks, users can instead leave their files in any directory, and dynamically load them from Power Query using something like the function below (adjust the hard-coded file path to match the directory you put them in).

To add the Load query, click 'From Other Sources' in the Power Query ribbon tab, select 'Blank Query' (bottom option), open the Advanced Editor in the View tab, and paste in the below snippet (after adjusting file path). Click Done, name the query 'Load', and click 'Apply & Close' in the Home tab.

Unfortunately this Load function will need to be present within any workbook wanting to make use of dynamic loading of code libraries, but this should beat the alternative of having to add and sync every single function you are interested in.


-------------------------------------

    let Load = (fnName as text) =>
    let
        BasePath = "C:\PQuery\",
        File = BasePath & fnName & ".m",
        Source = Text.FromBinary(File.Contents(File)),
        Function = Expression.Evaluate(Source, #shared)
    in
        Function
    in
        Load

-------------------------------------


The main point here is that by separating universally useful functions from an individual workbook, you will feel encouraged to use more modular code, solving each common sub-problem only once, rather than remaining stuck in 'vanilla' M and resolving the same problems repeatedly.

Moreover, coding this way will also facilitate sharing code with other Power Query users (without requiring a Power BI subscription), allowing for a more collaborative environment.

Admittedly, Microsoft languages have rarely been known for encouraging open-source collaboration, and the Power Query community is currently small. But will that mean we cannot assemble a powerful code library like those of the JavaScript community?

