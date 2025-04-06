
# v8 Iteration

This iteration of the ColdFusion + HTMX application adds realtime search functionality to the contacts list. In addition to the existing click-based form submission (which continues to work even if the HTMX library doesn't load), the contact list results will now be proactively updated as the user types in the search input.

I've removed the "infinite scroll" functionality since I wanted to make sure that the prev/next pagination would work in conjunction with this update.

And, speaking of the prev/next pagination, this demo works by swapping out just the `.search-results` portion of the page. The prev/next links, however, sit outside this container; and, have to be swapped using an OOB (Out of Band) selection. In the end, here's the new input element:

```cfm
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
/>
```

When HTMX makes this request, it will select the `.search-results` out of the AJAX response and merge them into the `.search-results` (using `innerHTML`) that is already rendered on the page. It will also swap the `#pagination` out of the AJAX response and merge it into the `#pagination` (using `outerHTML`) that is already rendered on the page.

Note that the the `hx-select-oob` has some tighter constraints. First, it must be id-driven - it can't use a generic CSS selector like other HTMX attributes. And second, it's default swap strategy is `outerHTML`, not `innerHTML`; though, this can be overridden in the `hx-select-oob` attribute value.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "Adding Active Search".


[hypermedia-chapter]: https://hypermedia.systems/more-htmx-patterns/#_adding_active_search
