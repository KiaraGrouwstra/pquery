/*
	Get report data from SAP Business ByDesign using Power Query (through OData)
	Pulls firstly report as OData send it, then get metadata of report, and rename IDs to Names
	
	ConnectionString = https://myXXXXXX.sapbydesign.com/sap/byd/odata/cc_home_analytics.svc/RPCRMCIVIB_Q0001QueryResults?$top=100000&
	$select=CDOC_YEAR,CDOC_MONTH,KCNT_VAL_INV,CDOC_CANC_IND&$filter=CDOC_YEAR eq '2015' and CDOC_STA_RELEASE eq '3'
	TenantId = "XXXXXX"
	ReportId = "CRMCIVIB_Q0001"  // Invoice Volume
*/

(TenantId as text, ReportId as text, ConnectionString) =>
let	
    start = Json.Document(Binary.Buffer(Web.Contents(ConnectionString & "&$format=json"))),
    d = start[d],
    results = d[results],

	transformation = () =>
		let
			table = Table.FromList(results, Splitter.SplitByNothing(), null, null, ExtraValues.Error),	
            expand = Table.ExpandRecordColumn(table, "Column1", List.RemoveItems(Record.FieldNames(table{0}[Column1]), {"__metadata"}) ),
			names = 
				let
					Source = Binary.Buffer(Web.Contents("https://my" & TenantId & ".sapbydesign.com/sap/byd/odata/cc_home_analytics.svc/$metadata?entityset=RP" & ReportId & "QueryResults")),
					Content = Xml.Tables(Source),
					DataServices = Content{0}[DataServices],
					#"http://schemas microsoft com/ado/2008/09/edm" = DataServices{0}[#"http://schemas.microsoft.com/ado/2008/09/edm"],
					#"Expand Schema" = Table.ExpandTableColumn(#"http://schemas microsoft com/ado/2008/09/edm", "Schema", {"EntityType"}, {"Schema.EntityType"}),
					#"Expand Schema.EntityType2" = Table.ExpandTableColumn(#"Expand Schema", "Schema.EntityType", {"Property"}, {"Property"}),
					#"Expand Property" = Table.ExpandTableColumn(#"Expand Schema.EntityType2", "Property", {"Attribute:Name", "http://www.sap.com/Protocols/SAPData"}, {"Attribute:Name", "http://www.sap.com/Protocols/SAPData"}),
					#"Expand http://www.sap.com/Protocols/SAPData" = Table.ExpandTableColumn(#"Expand Property", "http://www.sap.com/Protocols/SAPData", {"Attribute:label"}, {"Attribute:label"}),
					#"Renamed Columns" = Table.RenameColumns(#"Expand http://www.sap.com/Protocols/SAPData",{{"Attribute:Name", "Id"}, {"Attribute:label", "Name"}}),
					res = Table.SelectRows(#"Renamed Columns", each ([Id] <> "ID" and [Id] <> "TotaledProperties"))
				in
					res,
			result = Table.RenameColumns(expand, Table.ToColumns(Table.Transpose(names)), MissingField.Ignore)
		in 
			result,

	output = if List.IsEmpty(results) then null
		else transformation()
in
	output
