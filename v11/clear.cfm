<cfscript>

	contactModel.deleteByFilter();

	goto( "index.cfm?flash=contact.cleared" );

</cfscript>
