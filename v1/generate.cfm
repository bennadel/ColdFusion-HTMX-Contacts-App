<cfscript>

	contactModel.create( "Emily Thomas",    "555-1111",  "emily.thomas@example.com" );
	contactModel.create( "David Mitchell",  "555-2222",  "david.mitchell@example.com" );
	contactModel.create( "Dylan Lee",       "555-3333",  "dylan.lee@example.com" );
	contactModel.create( "Riley Smith",     "555-4444",  "riley.smith@example.com" );
	contactModel.create( "Joseph Jackson",  "555-5555",  "joseph.jackson@example.com" );
	contactModel.create( "David Jones",     "555-6666",  "david.jones@example.com" );
	contactModel.create( "Ellie Mitchell",  "555-7777",  "ellie.mitchell@example.com" );
	contactModel.create( "Ethan Scott",     "555-8888",  "ethan.scott@example.com" );
	contactModel.create( "Luna Rodriguez",  "555-9999",  "luna.rodriguez@example.com" );
	contactModel.create( "Nova Gonzalez",   "555-0000",  "nova.gonzalez@example.com" );

	goto( "index.cfm?flash=contact.generated" );

</cfscript>
