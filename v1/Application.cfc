component {

	// Define the application settings.
	this.name = "HtmxContactsAppV1";
	this.applicationTimeout = createTimeSpan( 1, 0, 0, 0 );
	this.sessionManagement = false;
	this.setClientCookies = false;

	// Always scope unscoped variables to the function block. In this application, this is
	// particularly meaningful because we're including the requested scriptName into the
	// onRequest() event handler, essentially turning the requested script into a mixin
	// that executes in the context of the Application.cfc instance. The localMode,
	// therefore, prevents script-level variables from leaking into the Application.cfc
	// context / variables scope.
	this.localMode = "modern";

	// Set up application mappings.
	this.appRoot = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings = {
		"/shared": "#this.appRoot#../shared"
	};

	// ---
	// LIFE-CYCLE MEHTODS.
	// ---

	/**
	* I execute the requested script.
	*/
	public void function onRequest( required string scriptName ) {

		var contactModel = new shared.lib.ContactModel();

		// Check for model reset.
		if ( url?.clear == 1 ) {

			contactModel.deleteByFilter();

		}

		// Note: since we're pulling the requested script into the Application.cfc
		// context, the function-local variables and the mix-in methods are now available
		// in the requested template execution.
		include scriptName;

	}


	/**
	* I handle uncaught errors.
	*/
	public void function onError( required any error ) {

		header
			statusCode = 500
		;

		echo( "An unexpected error occurred:" );
		echo( encodeForHtml( error.message ) );

	}

	// ---
	// MIX-IN METHODS.
	// ---

	/**
	* I goto the given resource.
	*/
	public void function goto( required string resource ) {

		location( url = resource, addToken = false );

	}

}
