<cfscript>

	demoContacts = new shared.lib.DemoData()
		.getContacts()
	;

	for ( contact in demoContacts ) {

		if ( contactModel.getByFilter( email = contact.email ).len() ) {

			continue;

		}

		contactModel.create( argumentCollection = contact );

	}

	goto( "index.cfm?flash=contact.generated" );

</cfscript>
