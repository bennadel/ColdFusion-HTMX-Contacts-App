component {

	// Define the application settings.
	// --
	// Note: Since we're not caching anything in the application scope (contact data is
	// cached in the server scope), we're going to use the same application name for each
	// version. This way, we're not creating new memory spaces for each iteration. The
	// Application.cfc is still instantiated on every request; and, any version-specific
	// settings should still apply to the correct version of the app.
	this.name = "HtmxContactsApp";
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

		// When HTMX implements a request via AJAX, it will include some subset of these
		// HTTP headers. However, each individual header is only sent to the server when
		// it is relevant. In this case, I'm defaulting every header to the empty string
		// in order to make consumption on the server-side a little easier.
		request.htmx = {
			boosted: ( safelyGetHeader( "HX-Boosted" ) == "true" ),
			currentUrl: safelyGetHeader( "HX-Current-URL" ),
			historyRestoreRequest: safelyGetHeader( "HX-History-Restore-Request" ),
			prompt: safelyGetHeader( "HX-Prompt" ),
			request: ( safelyGetHeader( "HX-Request" ) == "true" ),
			target: safelyGetHeader( "HX-Target" ),
			triggerName: safelyGetHeader( "HX-Trigger-Name" ),
			trigger: safelyGetHeader( "HX-Trigger" )
		};

		var contactModel = new shared.lib.ContactModel();

		// Note: since we're pulling the requested script into the Application.cfc
		// context, the function-local variables and the mix-in methods are now available
		// in the requested template execution.
		include scriptName;

	}


	/**
	* I handle uncaught errors.
	*/
	public void function onError( required any error ) {

		// Handle special cases for error codes.
		switch ( error.type ) {
			case "Model.NotFound":
				var statusCode = 404;
				var title = "Not Found";
				var message = error.message;
			break;
			default:
				var statusCode = 500;
			break;
		}

		include "_error.cfm";

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


	/**
	* I determine if the incoming HTTP request is a DELETE.
	*/
	public boolean function isHttpDelete() {

		return ( cgi.request_method == "delete" );

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I get the HTTP headers send with the current request.
	*/
	private struct function getHttpHeaders()
		cachedWithin = "request"
		{

		return getHttpRequestData( false ).headers;

	}


	/**
	* I get the HTTP header with the given name, falling back to the empty string.
	*/
	private string function safelyGetHeader( required string name ) {

		var headers = getHttpHeaders();

		return ( headers[ name ] ?: "" );

	}

}
