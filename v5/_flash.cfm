<cfscript>

	if ( isNull( url.flash ) ) {

		exit;

	}

</cfscript>
<cfoutput>

	<p class="flash">
		<cfswitch expression="#url.flash#">
			<cfcase value="contact.cleared">
				Your contact demo data has been cleared.
			</cfcase>
			<cfcase value="contact.created">
				Your contact has been created.
			</cfcase>
			<cfcase value="contact.generated">
				Your contact demo data has been generated.
			</cfcase>
			<cfcase value="contact.updated">
				Your contact has been updated.
			</cfcase>
			<cfcase value="contact.deleted">
				Your contact has been deleted.
			</cfcase>
		</cfswitch>
	</p>

</cfoutput>
