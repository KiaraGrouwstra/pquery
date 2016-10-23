/*
        Get report data from SAP Business ByDesign using Power Query (through OData)
	Example:	
	ConnectionString = https://myXXXXXX.sapbydesign.com/sap/byd/odata/cc_home_analytics.svc/RPCRMCIVIB_Q0001QueryResults?$top=100000&
	$select=CDOC_YEAR,CDOC_MONTH,KCNT_VAL_INV,CDOC_CANC_IND&$filter=CDOC_YEAR eq '2015' and CDOC_STA_RELEASE eq '3'
*/

(ConnectionString) =>
let	
    start = Json.Document(Binary.Buffer(Web.Contents(ConnectionString & "&$format=json"))),
    d = start[d],
    results = d[results],

	transformation = () =>
		let
			table = Table.FromList(results, Splitter.SplitByNothing(), null, null, ExtraValues.Error),	
            expand = Table.ExpandRecordColumn(table, "Column1", List.RemoveItems(Record.FieldNames(table{0}[Column1]), {"__metadata"}) )						
		in 
			expand,

	output = if List.IsEmpty(results) then null
		else transformation()
in
	output
