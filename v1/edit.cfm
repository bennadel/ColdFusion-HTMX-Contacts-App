<cfscript>

	param name="url.id" type="numeric";
	param name="form.submitted" type="boolean" default=false;
	param name="form.name" type="string" default="";
	param name="form.phone" type="string" default="";
	param name="form.email" type="string" default="";

	contact = contactModel.get( val( url.id ) );
	title = "Edit #contact.name#";
	errorMessage = "";

	if ( form.submitted ) {

		try {

			contactModel.update(
				id = contact.id,
				name = form.name.trim(),
				phone = form.phone.trim(),
				email = form.email.trim()
			);

			goto( "index.cfm?flash=contact.updated" );

		// To keep things super simple in this demo app, we're going to assume that all
		// MODEL errors have a user-safe message and result in a 422 status code.
		} catch ( Model error ) {

			statusCode = 422;
			errorMessage = error.message;

		}

	} else {

		form.name = contact.name;
		form.phone = contact.phone;
		form.email = contact.email;

	}

</cfscript>

<cfsavecontent variable="body">
<cfoutput>

	<h1>
		#encodeForHtml( title )#
	</h1>

	<cfinclude template="_errorMessage.cfm">

	<form method="post" action="edit.cfm?id=#encodeForUrl( contact.id )#">
		<input type="hidden" name="submitted" value="true" />

		<p class="form-field">
			<label for="name">
				Name:
			</label>
			<input
				id="name"
				type="text"
				name="name"
				value="#encodeForHtmlAttribute( form.name )#"
			/>
		</p>
		<p class="form-field">
			<label for="phone">
				Phone:
			</label>
			<input
				id="phone"
				type="text"
				name="phone"
				value="#encodeForHtmlAttribute( form.phone )#"
			/>
		</p>
		<p class="form-field">
			<label for="email">
				Email:
			</label>
			<input
				id="email"
				type="text"
				name="email"
				value="#encodeForHtmlAttribute( form.email )#"
			/>
		</p>

		<p class="form-buttons">
			<button type="submit">
				Submit
			</button>
			<a href="view.cfm?id=#encodeForUrl( contact.id )#">
				Cancel
			</a>
		</p>
	</form>

	<hr />

	<form method="post" action="delete.cfm?id=#encodeForUrl( contact.id )#">
		<input type="hidden" name="submitted" value="true" />
		<button type="submit">
			Delete Contact
		</button>
	</form>

</cfoutput>
</cfsavecontent>

<cfinclude template="_layout.cfm">
