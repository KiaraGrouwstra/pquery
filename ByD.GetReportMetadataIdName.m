/*
        Get report data from SAP Business ByDesign using Power Query (through OData)
	ByD.GetReportMetadataIdName pulls two columns Id and Name from report metadata
	
*/

(TenantId as text, ReportId as text) =>
let
    Source = Binary.Buffer(Web.Contents("https://my" & TenantId & ".sapbydesign.com/sap/byd/odata/cc_home_analytics.svc/$metadata?entityset=RP" & ReportId & "QueryResults")),
    Content = Xml.Tables(Source),
    DataServices = Content{0}[DataServices],
    #"http://schemas microsoft com/ado/2008/09/edm" = DataServices{0}[#"http://schemas.microsoft.com/ado/2008/09/edm"],
    #"Expand Schema" = Table.ExpandTableColumn(#"http://schemas microsoft com/ado/2008/09/edm", "Schema", {"EntityType"}, {"Schema.EntityType"}),
    #"Expand Schema.EntityType2" = Table.ExpandTableColumn(#"Expand Schema", "Schema.EntityType", {"Property"}, {"Property"}),
    #"Expand Property" = Table.ExpandTableColumn(#"Expand Schema.EntityType2", "Property", 
		{"Attribute:Name", "http://www.sap.com/Protocols/SAPData"}, {"Attribute:Name", "http://www.sap.com/Protocols/SAPData"}),
    #"Expand http://www.sap.com/Protocols/SAPData" = Table.ExpandTableColumn(#"Expand Property", "http://www.sap.com/Protocols/SAPData", {"Attribute:label"}, {"Attribute:label"}),
    #"Renamed Columns" = Table.RenameColumns(#"Expand http://www.sap.com/Protocols/SAPData",{{"Attribute:Name", "Id"}, {"Attribute:label", "Name"}}),
	res = Table.SelectRows(#"Renamed Columns", each ([Id] <> "ID" and [Id] <> "TotaledProperties"))
in
    res
