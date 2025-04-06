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
	</head>
	<body>

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