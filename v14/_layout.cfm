<cfscript>

	param name="statusCode" type="numeric" default=200;
	param name="title" type="string" default="Contacts App";
	param name="body" type="string";

	header
		statusCode = statusCode
	;
	content
		type = "text/html; charset=utf-8"
	;

</cfscript>
<cfoutput>

	<!doctype html>
	<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>
			#encodeForHtml( title )#
		</title>
		<link rel="stylesheet" type="text/css" href="/shared/static/main.css">
		<script type="text/javascript" src="/shared/static/htmx-2.0.4.min.js"></script>
		<script type="text/javascript">

			// By default, htmx won't swap 422 Unprocessible Entity responses, which is
			// what we're using in our model validation error responses. As such, we have
			// to override the response handling configuration to apply swap for certain
			// types of error status codes. I'm also configuring 404 Not Found errors to
			// be swapped as well.
			// --
			// See: <!--- https://htmx.org/docs/#response-handling --->
			htmx.config.responseHandling = [
				{ code: "204",    swap: false },
				{ code: "[23]..", swap: true },

				// Override 404 to render Not Found error content.
				{ code: "404",    swap: true, error: true },
				// Override 422 to render Unprocessible Entity error content.
				{ code: "422",    swap: true },

				{ code: "[45]..", swap: false, error: true },
				{ code: "...",    swap: true }
			];

		</script>
	</head>
	<body hx-boost="true" hx-sync="this:replace">

		<div class="site">

			<cfinclude template="_flash.cfm">

			<main>
				#body#
			</main>

			<footer>
				<hr />
				<p>
					Rendered #timeFormat( now(), "hh:mm:ss" )#
					&mdash;
					ColdFusion + HTMX Demo App
				</p>
			</footer>

		</div>

	</body>
	</html>

</cfoutput>