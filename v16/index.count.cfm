<cfscript>

	// The book says this request takes a second and a half.
	sleep( 1500 );

	contacts = contactModel.getByFilter();

</cfscript>
<cfoutput>

	(#numberFormat( contacts.len() )# in total)

</cfoutput>
