
# v16 Iteration

This iteration of the ColdFusion + HTMX application adds a "download contacts" feature. This exploration is a little janky because it attempts to explore a long-running asynchronous process (to generate the file); but, in reality, the process would be instant. As such, I have to jump through a number of hoops to _simulate_ what the workflow would look like.

Ultimately, there's a `div` at the bottom of the list page that runs the main contents of a different page:

```cfm
<div
	hx-target="this"
	hx-select=".downloader"
	hx-push-url="false"
	class="downloader">

	<a href="download.cfm?action=start">Download contact list</a>
</div>
```

When the user clicks the "Download" link, HTMX will "boost" the request; but, instead of targeting the `body` element like HTMX would normally, we are inheriting the `hx-target="this"` attribute to contain the requested content. Then, we're using the `hx-select` to only grab the portion of the content with the matching class name, `.downloader`.

The `download.cfm` page then executes a polling operation, making repeated requests until a randomly selected duration has passed. As I mentioned above, there is no actual generation that's happening. As such, this is all theater.

That said, the download page uses the same kind of containment mechanism as above so that the same content will continue to be swapped locally even if the download link is opened in a new tab (ie, the download page uses the same mechanics).

The following was the lightest-weight way to perform this simulation - this is not an example of any best practices. I'm reproducing this file in full down below since I am too tired to explain it in any mediated way:

```cfm
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
```

It's kind of cool to see it all come together - and with relatively little effort.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "A Dynamic Archive UI".


[hypermedia-chapter]: https://hypermedia.systems/a-dynamic-archive-ui/
