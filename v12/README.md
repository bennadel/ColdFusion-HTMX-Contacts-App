
# v12 Iteration

This iteration of the ColdFusion + HTMX application adds the lazy loading of the total count of contacts. We are artificially slowing this request down (1.5 seconds) to make sure that it's an expensive request. Then, we're using `hx-trigger="load"` to only make the request after the parent page has loaded.

The `index.count.cfm` page does nothing but render the snippet of text that outputs the count:

```cfml
<cfscript>

	sleep( 1500 );
	contacts = contactModel.getByFilter();

</cfscript>
<cfoutput>

	(#numberFormat( contacts.len() )# in total)

</cfoutput>
```

The trigger for this expensive request is being done from within the title tag:

```cfml
<h1>
	Contacts App

	<span
		hx-sync="this"
		hx-get="index.count.cfm"
		hx-trigger="load">
		<!--- Lazy load the contacts length. --->
	</span>
</h1>
```

Recall that in an earlier iteration, I added `hx-sync="this:replace"` on the `<body>` tag. This forces all requests to synchronize on the content root (which mirrors the browser's native behavior). However, we don't necessarily want this lazy loading to interact with that pool of requests. As such, I'm including an `hx-sync` attribute on the lazy loading content in order to isolate it within its own synchronization pool.

This is so easy to do!

But, once I had this in place, I noticed that when I paged through the results, each page was causing the count to re-fetch. This is because the pagination itself is doing a full page refresh. This navigation is still _boosted_; but, it's clearing out the whole page, causing the lazy loaded contact count to re-fetch.

This was a bit distracting. So, I updated the prev/next links to perform partial page swapping instead of whole page swapping. By adding `hx-*` attributes to the pagination root, they will be inherited by both the prev and next links:

```cfml
<div
	id="pagination"
	class="pagination"

	hx-push-url="true"
	hx-swap="show:window:top"
	hx-target=".search-results"
	hx-select=".search-results"
	hx-select-oob="pagination">

	<cfif pagination.hasPrevious>
		<a href="index.cfm?q=#encodeForUrl( url.q )#&page=#( pagination.page - 1 )#&pageSize=#( pagination.pageSize )#">
			&larr; <u>Prev</u>
		</a>
	</cfif>

	<cfif pagination.hasNext>
		<a href="index.cfm?q=#encodeForUrl( url.q )#&page=#( pagination.page + 1 )#&pageSize=#( pagination.pageSize )#">
			<u>Next</u> &rarr;
		</a>
	</cfif>
</div>
```

Here, the `hx-target` and `hx-select` attribute perform the partial page swap (instead of the whole page swap). And, on top of that, I'm using the `hx-select-oob` to also perform an out-of-band swap of the contents of the pagination such that we don't show an erroneous prev or next link when it's no longer needed.

By default, HTMX seems to scroll to the `hx-target` element upon swap. This was causing my prev/next links to jump _down_ on the page. But, this felt unnatural. I wanted the prev/next links to still look and feel like full page loads. As such, I also added:

`hx-swap="show:window:top"`

This tells HTMX to scroll to the "top" of the "window" when the content is swapped-in / shown.

> **Aside**: I think there's a way to vastly simplify some of the search interactions; but, I'll look at that in a future iteration.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "Lazy Loading".


[hypermedia-chapter]: https://hypermedia.systems/more-htmx-patterns/#_lazy_loading
