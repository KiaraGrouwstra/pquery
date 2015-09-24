pquery
======

This is a collection of functions written in the M language for use in Microsoft Excel's [Power Query plugin](http://office.microsoft.com/en-us/excel/download-microsoft-power-query-for-excel-FX104018616.aspx).

Rather than manually adding the functions to different Excel workbooks, users can instead leave their files in any directory, and either batch import them into your workbook using Excel 2016 VBA (see my sample workbook [here](http://1drv.ms/1GmrhDl)), or by dynamically loading them into Power Query using something like the `Load()` function (see `Load.m`). To use Load() you'll need to add it to every applicable workbook though. You can hard-code in the path to the folder where you put the functions from this repository, or set it in the specified cell in the above-mentioned sample workbook for use in that.

To manually add the Load query, click 'From Other Sources' in the Power Query ribbon tab, select 'Blank Query' (bottom option), open the Advanced Editor in the View tab, and paste in the below snippet (after adjusting file path). Click Done, name the query 'Load', and click 'Apply & Close' in the Home tab.

If you have your M queries in files, you may well prefer to edit them from a text editor like Notepad++. With Matt Mason's [language file](http://www.mattmasson.com/2014/11/notepad-language-file-for-the-power-query-formula-language-m/) for this you will get nice color coding too! 

The main point here is that by separating universally useful functions from an individual workbook, you will feel encouraged to use more modular code, solving each common sub-problem only once, rather than remaining stuck in 'vanilla' M and resolving the same problems repeatedly.

Moreover, coding this way will also further facilitate sharing code with other Power Query users, allowing for a more collaborative environment.

Admittedly, Microsoft languages have rarely been known for encouraging open-source collaboration, and the Power Query community is currently small. But will that mean we cannot assemble a powerful code library like those of the JavaScript community?

