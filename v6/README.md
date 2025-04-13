
# v6 Iteration

This iteration of the ColdFusion + HTMX application updates the basic pagination of the contacts list to include a "load more" button at the bottom of the list. The load more button will use the existing pagination mechanics; and will take the new `<tr>` nodes returned in the paged response and append them to the table:

```cfm
<cfif pagination.hasNext>
	<tr>
		<td colspan="4">

			<button
				hx-get="index.cfm?q=#encodeForUrl( url.q )#&page=#( pagination.page + 1 )#&pageSize=#( pagination.pageSize )#"
				hx-target="closest tr"
				hx-swap="outerHTML"
				hx-select="tbody > tr"
				type="button"
				class="load-more">
				Load More
			</button>

		</td>
	</tr>
</cfif>
```

Notice that the `hx-target` is the `closest tr` - it will replace the entire row that contains the button itself. And, the content that it injects is the `hx-select="tbody tr`.

I don't love that the "load more" button is physically inside the table - this doesn't feel like a semantically correct pattern to me. But, keeping the button in the table makes it easy to both add new rows and to conditionally stop showing the button when there are no more rows to show. Perhaps when I learn more about OOB (out of band) swaps, I'll be able to handle this more elegantly.

I'm leaving the prev/next functionality in place to make this change additive.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "Click To Load".


[hypermedia-chapter]: https://hypermedia.systems/htmx-patterns/#_click_to_load
