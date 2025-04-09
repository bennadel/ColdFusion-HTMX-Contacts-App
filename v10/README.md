
# v10 Iteration

This iteration of the ColdFusion + HTMX application adds a request indicator to the contact list search form to indicate that a request is currently in-flight. These busy indicators are a first-class citizen of HTMX and can be managed through the `htmx-indicator` CSS class and / or the `hx-indicator` attribute.

The `hx-indicator` attribute uses a CSS selector to point to the element (or elements) to be treated as the request indicators. During the in-flight request workflow, HTMX uses special CSS classes to change the visibility (opacity) of the request indicator. The opacity-based styles are automatically injected by the HTXM library; but, you can override the CSS properties in your own CSS if you need to.

For this iteration, I've added a `Loading...` span after the submit button. Here's part of my search form:

```cfml
<form method="get" class="linear-form">
	<label for="search">
		Search contacts:
	</label>
	<input
		id="search"
		type="text"
		name="q"
		value="#encodeForHtmlAttribute( url.q )#"

		hx-get="index.cfm"
		hx-push-url="true"
		hx-trigger="input delay:200ms"
		hx-target=".search-results"
		hx-select=".search-results"
		hx-select-oob="pagination"

		hx-indicator=".htmx-indicator"
	/>
	<button type="submit">
		Search
	</button>

	<span class="htmx-indicator">
		Loading....
	</span>
</form>
```

Since the `htmx-indicator` class is applied to an element that is a child of the `<form>`, HTMX automatically treats it as the request indicator when the form is submitted. However, this isn't true for the `hx-get` attribute on the search input. To use the same indicator for the _active search_ (ie, the search triggered by the input), we have to use the `hx-indicator` attribute to point to the `Loading....` element.

To make this demo more intelligible, I've also added an artificial 5-second delay to any request that has a populated `q` value. This gives the `Loading....` indicator time to actively contribute to the user experience.

Another change that I made to the application is that I added an `hx-sync` attribute on the body tag:

```cfml
<body hx-boost="true" hx-sync="this:replace">
```

By default, the `hx-boost` does _not cancel_ any in-flight requests as the user navigates around the application. Which means, if the user triggers an "active search" request (which is artificially slowed-down in this iteration), and then immediately navigates to another page (such as a contact detail), the active search request will continue to run in the background. And, will be applied to the DOM and URL when it completes. This can lead to unexpected experiences.

By adding `hx-sync="this:replace"` to the body tag, it's inherited by the entire app; and, as the user navigates to any page or triggers any AJAX requests, each request will immediately cause any in-flight requests to be aborted. This is more in alignment (in my opinion) with how the browser works natively.

Of course, you can always override this inherited `hx-sync` behavior by adding an `hx-sync` attribute lower down in the DOM tree if there's an area of interactions that you want to manage explicitly.

> **Aside**: I opened a [discussion about `htmx:abort`][gh-issue] over on GitHub and [Vincent/@telroshan][telroshan] had some great feedback about why the `hx-sync` default behavior was in place (such as debouncing double-clicks); and also pointed out some of the trade-offs in synchronizing requests on the root. I think for the time being, I want to keep the synchronizing on the root (since this is closer to the normal behavior of the browser). But this definitely gave me a lot to think about. There are no "obviously right" solutions.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "Adding A Request Indicator".


[gh-issue]: https://github.com/bigskysoftware/htmx/discussions/3269

[hypermedia-chapter]: https://hypermedia.systems/more-htmx-patterns/#_adding_an_indicator

[telroshan]: https://github.com/Telroshan
