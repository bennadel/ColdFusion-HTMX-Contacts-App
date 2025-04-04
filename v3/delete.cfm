<cfscript>

	param name="url.id" type="numeric";
	param name="url.submitted" type="boolean" default=false;

	contact = contactModel.get( val( url.id ) );
	title = "Delete #contact.name#";
	errorMessage = "";

	if ( isHttpDelete() && url.submitted ) {

		try {

			// This is a test to see how the workflow responds to error messages.
			// Otherwise, we don't have a good way to trigger an error in this workflow.
			if ( contact.name.reFindNoCase( "^Diva\b" ) ) {

				throw(
					type = "Model.Validation",
					message = "Contacts with the name Diva cannot be deleted."
				);

			}

			contactModel.deleteByFilter( id = contact.id );

			goto( "index.cfm?flash=contact.deleted" );

		// To keep things super simple in this demo app, we're going to assume that all
		// MODEL errors have a user-safe message and result in a 422 status code.
		} catch ( Model error ) {

			statusCode = 422;
			errorMessage = error.message;

		}

	}

</cfscript>

<cfsavecontent variable="body">
<cfoutput>

	<h1>
		#encodeForHtml( title )#
	</h1>

	<cfinclude template="_errorMessage.cfm">

	<p class="form-buttons">
		<button
			hx-delete="delete.cfm?id=#encodeForUrl( contact.id )#&submitted=true"
			hx-target="body"
			hx-push-url="true"
			type="button">
			Delete
		</button>
		<a href="view.cfm?id=#encodeForUrl( contact.id )#">
			Cancel
		</a>
	</p>

</cfoutput>
</cfsavecontent>

<cfinclude template="_layout.cfm">
