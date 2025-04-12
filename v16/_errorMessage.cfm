<cfscript>

	param name="errorMessage" type="string";

	if ( ! errorMessage.len() ) {

		exit;

	}

</cfscript>
<cfoutput>

	<p class="error-message">
		#encodeForHtml( errorMessage )#
	</p>

</cfoutput>
