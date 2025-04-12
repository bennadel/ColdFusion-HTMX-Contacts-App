<cfscript>

	contacts = contactModel.getByFilter();
	data = serializeJson( contacts );

	header
		name = "Content-Disposition"
		value = "attachment; filename=contacts.json"
	;
	content
		type = "application/x-json; charset=utf-8"
		variable = charsetDecode( data, "utf-8" )
	;

</cfscript>
