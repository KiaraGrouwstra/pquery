/*
Allows dynamically loading an M function from a text file (extension: .pq) in a given folder for use in Power Query. This allows you to easily reuse  a set of functions in multiple workbooks without having to sync each change to all files using it.

The point here is that by separating universally useful functions from an individual workbook, you will feel encouraged to use more modular code,  solving each common sub-problem only once, rather than remaining stuck in 'vanilla' M and resolving the same problems repeatedly.

Moreover, coding this way will also further facilitate sharing code with other Power Query users, allowing for a more collaborative environment, gradually pushing forward the Power Query community as a whole.

Nevertheless, if the function in question has already been imported into the workbook, the local copy will be used. This would allow you to either call the function locally right away, or Load() the existing function again.

Using Load() would not only allow you to use functions in their intended naming conventions (i.e. Text.ReplaceAll rather than with the period replaced by an underscore), but would technically also allow you to add additional wrapper functions around your code, which could be used to enable persistent memoization (using say Redis) or code profiling calls... though presumably no-one has done this so far yet.

Parameters:
    fnName: name of the text file you wish to load without the .pq extension
	optional BasePath: the file path to look in for the text file; default path hardcoded

Usage:
    // loads the function Type.ToText from file 'Type.ToText.pq' in the load path
let
    Type.ToText = Load("Type.ToText")
in
    Type.ToText(type {number})

// Result: "list"

Warning: this function may triggers a Formula.Firewall error for referencing both an external query (LoadPath) as well as external files.

If you run into this, you can get around this by enabling the FastCombine option, in Power Query Options -> Privacy -> Fast Combine -> 'Ignore the 
Privacy levels and potentially improve performance'.

If you'd prefer not to do this however, you could also just replace the LoadPath/DefaultPath reference below with a static
absolute path reference.

*/

(fnName as text, optional BasePath as text) as function =>
// IvanBond version
let
    //If you wish to hardcode the path to load the queries from, you can edit the following line:
    DefaultPath = "C:\PQuery\",
    GitHubPath = "https://raw.githubusercontent.com/hohlick/pquery/master/",
    
    BasePath = if (BasePath <> null) then BasePath else DefaultPath,
    Path = BasePath & (if Text.End(BasePath, 1) <> "\" then "\" else ""),
    File = Path & fnName & ".pq",
    
    Function = try Expression.Evaluate(Text.Replace(fnName, ".", "_"), #shared)  //if already imported into the workbook just use the existing one
	otherwise try Expression.Evaluate(Text.FromBinary(Binary.Buffer(File.Contents(File))), #shared) //if not imported yet try loading it from the text file in the folder
	otherwise Expression.Evaluate( Text.FromBinary(Binary.Buffer(Web.Contents(GitHubPath & fnName & ".pq"))), #shared) // if folder not found - take from GitHubPath
in
	Function
/*
Here comes old Load.pq function:	

(fnName as text, optional BasePath as text) as function =>

let
    //If you wish to hardcode the path to load the queries from, you can edit the following line:
    DefaultPath = LoadPath,
    //DefaultPath = "D:\pquery",
    BasePath = if (BasePath<>null) then BasePath else DefaultPath,
	Path = BasePath & (if Text.End(BasePath, 1) <> "\" then "\" else ""),
    File = Path & fnName & ".pq",
    AltFile = Path & Text.Replace(fnName, "_", ".") & ".pq",  //just in case...
    Source = Text.FromBinary(Binary.Buffer(
		try File.Contents(File)
		otherwise File.Contents(AltFile)
	)),
    Function = try Expression.Evaluate(Text.Replace(fnName, ".", "_"), #shared)  //if already imported into the workbook just use the existing one
		otherwise Expression.Evaluate(Source, #shared)	//if not imported yet try loading it from the text file in the folder
in
    Function
*/
