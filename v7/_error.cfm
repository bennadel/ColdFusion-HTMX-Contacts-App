<cfscript>

	param name="statusCode" type="numeric" default=500;
	param name="title" type="string" default="An Error Occurred";
	param name="message" type="string" default="An unexpected error occurred on the server.";

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
	</head>
	<body>

		<h1>
			#encodeForHtml( title )#
		</h1>

		<p>
			#encodeForHtml( message )#
		</p>

		<p>
			<a href="index.cfm">Return to the homepage</a>.
		</p>

	</body>
	</html>

</cfoutput>
