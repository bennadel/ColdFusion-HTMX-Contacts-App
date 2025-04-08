
# v10 Iteration




This is a WIP - it's not currently aborting requests as expected.




This iteration of the ColdFusion + HTMX application adds a request indicator to the contact list search form to indicate that a request is currently in-flight. These busy indicators are a first-class citizen of HTMX and can be managed through the `htmx-indicator` CSS class and / or the `hx-indicator` attribute.

The `hx-indicator` attribute uses a CSS selector to point to the element (or elements) to be treated as the request indicators. During the in-flight request workflow, HTMX uses special CSS classes to change the visibility (opacity) of the request indicator. The opacity-based styles are automatically injected by the HTXM library; but, you can override the CSS properties in your own CSS if you need to.

For this iteration, I've added a `Loading...` span after the submit button. Here's part of my search form:

```cfml
<form method="get" hx-sync="this:replace" class="linear-form">
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

		hx-indicator="##search-busy"
	/>
	<button type="submit">
		Search
	</button>

	<span id="search-busy" class="htmx-indicator">
		Loading....
	</span>
</form>
```

Since the `htmx-indicator` class is applied to an element that is a child of the `<form>`, HTMX automatically treats it as the request indicator when the form is submitted. However, this isn't true for the `hx-get` attribute on the search input. To use the same indicator for the _active search_ (ie, the search triggered by the input), we have to use the `hx-indicator` attribute to point to the `Loading....` element.

Another feature that I've added here is the `hx-sync` attribute on the form. By default, HTMX queues-up requests using a first-in-first-out (FIFO) strategy. But, with something like an active search feature, I think it makes more sense to abort the previous request as the user continues to type into the search field.

HTMX makes this possible through the `hx-sync` attribute, which I've added to the `<form>` tag:

`hx-sync="this:replace"`

Now, all the requests that are triggered under the form (either through form submission or the active search) use a `replace` strategy. That is, each new request will automatically abort and replace the previous request.

To make this demo more intelligible, I've also added an artificial 2-second delay to any request that has a populated `q` value. This gives the `Loading....` indicator and the `hx-sync` attribute time to actively contribute to the user experience.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "Adding A Request Indicator".


[hypermedia-chapter]: https://hypermedia.systems/more-htmx-patterns/#_adding_an_indicator
