
# v9 Iteration

This iteration of the ColdFusion + HTMX application adds the `request.htmx` struct to the request processing. When HTMX makes a request to the server, it will include a subset of HTTP headers that are relevant to the current interaction. I'm setting these up in the `onRequest()` event handler:

```cfc
component {

	public void function onRequest( required string scriptName ) {

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

	}

}
```

These values can then be used to conditionally render smaller partials for optimized database access and over-the-wire latency. My little app, however, isn't really setup to have this kind of differentiation. As such, I'm adding the above struct, but I'm not consuming it in any way at this time.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "HTTP Request Headers In Htmx".


[hypermedia-chapter]: https://hypermedia.systems/more-htmx-patterns/#_http_request_headers_in_htmx
