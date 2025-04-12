<cfscript>

	param name="url.id" type="numeric";
	param name="url.submitted" type="boolean" default=false;

	contact = contactModel.get( val( url.id ) );

	// Light-weight request validation.
	if ( ! isHttpDelete() || ! url.submitted ) {

		exit;

	}

	sleep( 200 );

	// This is a test to see how the workflow responds to error messages. Otherwise, we
	// don't have a good way to trigger an error in this workflow.
	if ( contact.name.reFindNoCase( "^Diva\b" ) ) {

		throw(
			type = "Model.Validation",
			message = "Contacts with the name Diva cannot be deleted."
		);

	}

	contactModel.deleteByFilter( id = contact.id );

	header
		name = "HX-Trigger"
		value = "contactDeleted"
	;

</cfscript>
<cfoutput>

	<tr class="deleted-row">
		<td colspan="4" style="text-align: center ;">
			#encodeForHtml( contact.name )# as been deleted.
		</td>
	</tr>

</cfoutput>
