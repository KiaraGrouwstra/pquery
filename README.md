# pquery

This is a collection of functions written in the M language for use in Microsoft Excel's [Power Query plugin](http://office.microsoft.com/en-us/excel/download-microsoft-power-query-for-excel-FX104018616.aspx).

## Introduction

Rather than manually adding the functions to different Excel workbooks, users can instead leave their files in any directory, and either batch import them into your workbook using Excel 2016 VBA (see my sample workbook [here](http://1drv.ms/1GmrhDl)), or by dynamically loading them into Power Query using something like the `Load()` function (see `Load.pq`). To use Load() you'll need to add it to every applicable workbook though. You can hard-code in the path to the folder where you put the functions from this repository, or set it in the specified cell in the above-mentioned sample workbook for use in that.

To manually add the Load query, click 'From Other Sources' in the Power Query ribbon tab, select 'Blank Query' (bottom option), open the Advanced Editor in the View tab, and paste in the below snippet (after adjusting file path). Click Done, name the query 'Load', and click 'Apply & Close' in the Home tab.

If you have your M queries in files, you may well prefer to edit them from a text editor like Notepad++. With Matt Mason's [language file](http://www.mattmasson.com/2014/11/notepad-language-file-for-the-power-query-formula-language-m/) for this you will get nice color coding too!

The main point here is that by separating universally useful functions from an individual workbook, you will feel encouraged to use more modular code, solving each common sub-problem only once, rather than remaining stuck in 'vanilla' M and resolving the same problems repeatedly.

Moreover, coding this way will also further facilitate sharing code with other Power Query users, allowing for a more collaborative environment.

Admittedly, Microsoft languages have rarely been known for encouraging open-source collaboration, and the Power Query community is currently small. But will that mean we cannot assemble a powerful code library like those of the JavaScript community?

## Usage

### to use M code in workbooks without having to import every query/function:

* [get](https://github.com/tycho01/pquery/archive/master.zip) and unzip this repo, or in case you'd like to contribute back, open a command prompt in your desired location (in Windows Explorer type `cmd` in the address bar) and run command `git clone https://github.com/tycho01/pquery.git`.
* copy [`LoadPath.example.pq`](https://github.com/tycho01/pquery/blob/master/LoadPath.example.pq) as `LoadPath.pq` and replace its entire content with the path where you put the query files; e.g. `"D:\pquery\"`.
* manually import the `Load.pq` and `LoadPath.pq` functions into your workbook, keeping their names as `Load` and `LoadPath`.
* now use the Load function to load queries from the folder you specified. i.e. if you write `Text_Between = Load("Text.Between"),`, it's going to give you the function located at `YOUR_PATH\Text.Between.pq`.

### to allow sharing your workbook:

* use [my Power Query workbook](http://1drv.ms/1GmrhDl) (requires Excel 2016) to batch import the desired queries into your workbook. Chris Webb also posted the used [VBA code](http://1drv.ms/1KUxm9g), and did an introductory [blog post](https://blog.crossjoin.co.uk/2015/06/10/power-queryexcel-2016-vba-examples/) about it.

## Related Projects (feel free to add!)
- [`Power-BI-Desktop-Query-Extensions`](https://github.com/tnclark8012/Power-BI-Desktop-Query-Extensions) - newer library including in-app function documentation
- [`PowerQueryExtensions`](https://github.com/Hugoberry/PowerQueryExtensions) - library using the recent [`DataConnectors`](https://github.com/Microsoft/DataConnectors) API to expose the functions from this and the above library
- [`m-tools`](https://github.com/acaprojects/m-tools) - functional programming helpers
- [`PowerQueryFunctional`](https://github.com/Hugoberry/PowerQueryFunctional) - `DataConnectors` port of the above library
- [`atom-language-m`](https://github.com/jaykilleen/atom-language-m) - Atom support for M
- [`LibPQ`](https://github.com/sio/LibPQ) - a collection of reusable modules for Power Query M Language

For more Power Query related repos check out some of the following users (sorted alphabetically, feel free to add!):
- [@acaprojects](https://github.com/acaprojects?tab=repositories)
- [@hohlick](https://github.com/hohlick?tab=repositories)
- [@Hugoberry](https://github.com/Hugoberry?tab=repositories)
- [@ImkeF](https://github.com/ImkeF/M/tree/master/Library)
- [@IvanBond](https://github.com/IvanBond?tab=repositories)
- [@maxim-uvarov](https://github.com/maxim-uvarov?tab=repositories)
