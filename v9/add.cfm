<cfscript>

	param name="form.submitted" type="boolean" default=false;
	param name="form.name" type="string" default="";
	param name="form.phone" type="string" default="";
	param name="form.email" type="string" default="";

	title = "Add New Contact";
	errorMessage = "";

	if ( form.submitted ) {

		try {

			contactModel.create(
				name = form.name.trim(),
				phone = form.phone.trim(),
				email = form.email.trim()
			);

			goto( "index.cfm?flash=contact.created" );

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

	<form method="post">
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
				hx-get="validateEmail.cfm"
				hx-trigger="input delay:200ms"
				hx-target="next .inline-error"
			/>
			<span class="inline-error">
				<!--- Populated by the HTMX call above. --->
			</span>
		</p>

		<p class="form-buttons">
			<button type="submit">
				Submit
			</button>
			<a href="index.cfm">
				Cancel
			</a>
		</p>
	</form>

</cfoutput>
</cfsavecontent>

<cfinclude template="_layout.cfm">
