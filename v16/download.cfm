<cfscript>

	param name="url.action" type="string" default="waiting";
	param name="url.startedAtMS" type="numeric" default=0;
	param name="url.completedAtMS" type="numeric" default=0;

	title = "Download Contact List";

	switch ( url.action ) {
		case "start":

			// When we start the download process, we're just going to select a fake
			// duration and pass the start/end times through with each request. This is
			// just to explore the workflow, not to be meaningful / correct.
			fakeDurationMS = randRange( 3000, 7000 );
			startedAtMS = getTickCount();
			completedAtMS = ( startedAtMS + fakeDurationMS );
			percentComplete = 0;

		break;
		case "run":

			// Calculate how close we are to the fake end-time.
			total = ( url.completedAtMS - url.startedAtMS );
			delta = ( getTickCount() - url.startedAtMS );
			percentComplete = fix( delta / total * 100 );

			// If we've passed 100% progress, the redirect to the download call to action.
			if ( percentComplete >= 100 ) {

				goto( "download.cfm?action=done" );

			}

		break;
	}

</cfscript>

<cfsavecontent variable="body">
<cfoutput>

	<h1>
		#encodeForHtml( title )#
	</h1>

	<div
		hx-target="this"
		hx-select=".downloader"
		hx-push-url="false"
		class="downloader">

		<cfswitch expression="#url.action#">
			<cfcase value="waiting">

				<a href="download.cfm?action=start">Start download</a>.

			</cfcase>
			<cfcase value="start,run">

				<div
					hx-get="download.cfm?action=run&startedAtMS=#encodeForUrl( startedAtMS )#&completedAtMS=#encodeForUrl( completedAtMS )#"
					hx-trigger="every 500ms">
					Generating... #encodeForHtml( percentComplete )#%
				</div>

			</cfcase>
			<cfcase value="done">

				<!--- Since this points to a download, we have to DISABLE BOOST. --->
				<a href="download.json.cfm" hx-boost="false">Download generated JSON file</a>.

			</cfcase>
		</cfswitch>

	</div>

</cfoutput>
</cfsavecontent>

<cfinclude template="_layout.cfm">
