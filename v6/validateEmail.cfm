<cfscript>

	param name="url.email" type="string";
	param name="url.id" type="numeric" default=0;

	url.email = url.email
		.trim()
		.lcase()
	;

	// This is a test to see how the workflow responds to error messages. Otherwise, we
	// don't have a good way to trigger an error in this workflow.
	if ( url.email == "test" ) {

		throw(
			type = "ServerError",
			message = "Something weng wrong, oh no!"
		);

	}

	// If the input isn't a valid looking email, no point in validating uniqueness yet.
	if ( ! url.email.reFind( "^[^@]+@[^.]+(\.[^.]+)+$" ) ) {

		exit;

	}

	existing = contactModel
		.getByFilter( email = url.email )
	;

	// If email isn't taken yet (or is taken by the current contact), then uniqueness
	// isn't an issue.
	if ( ! existing.len() || ( existing.first().id == url.id ) ) {

		exit;

	}

</cfscript>

<!--- If we made it this far, output the email uniqueness error. --->
<span class="inline-error-content">
	This email address is already taken.
</span>
