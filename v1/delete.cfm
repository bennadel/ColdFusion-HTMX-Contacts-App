<cfscript>

	param name="url.id" type="numeric";
	param name="form.submitted" type="boolean" default=false;

	contact = contactModel.get( val( url.id ) );
	title = "Delete #contact.name#";
	errorMessage = "";

	if ( form.submitted ) {

		try {

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

	<form method="post" action="delete.cfm?id=#encodeForUrl( contact.id )#">
		<input type="hidden" name="submitted" value="true" />

		<p class="form-buttons">
			<button type="submit">
				Delete
			</button>
			<a href="view.cfm?id=#encodeForUrl( contact.id )#">
				Cancel
			</a>
		</p>
	</form>

</cfoutput>
</cfsavecontent>

<cfinclude template="_layout.cfm">
