
# v15 Iteration

This iteration of the ColdFusion + HTMX application adds a bulk delete operation to the contacts list. Just as with the previous iteration, I've created a specialized end-point, sibling to the index page, that is designed for the bulk delete. However, unlike the one-off delete in the previous iteration, this version provides a checkbox-based selection; and, performs a full redirect of the page.

To start, I added a checkbox to each row that will report the associated contact ID as part of an array:

```cfm
<td>
	<input
		form="bulkForm"
		type="checkbox"
		name="contactIDs[]"
		value="#encodeForHtmlAttribute( contact.id )#"
	/>
</td>
```

Note that the `input` is using the `form` attribute to associate itself with a non-hierarchical form element. In the book, the authors wrapped the entire search results table in the `form` tag; but for me, that approach was conflicting with the `button` elements that I has previously added for the one-off deletes.

Instead, I put the `form` at the bottom of the page, and allowed the `form="bulkForm"` attributes to build the necessary associations. Even though there are no checkboxes located physically within the bounds of the form, the form submission will include any checked, associated input.

```cfm
<form
	id="bulkForm"
	method="post"
	action="index.deleteMany.cfm"

	hx-confirm="Are you sure you want to delete the selected contacts?">

	<!---
		Pass through the query and pagination settings so that we can
		re-route to this same page after deletion.
	--->
	<input type="hidden" name="q" value="..." />
	<input type="hidden" name="page" value="..." />
	<input type="hidden" name="pageSize" value="..." />

	<button type="submit">
		Delete Selected Contacts
	</button>
</form>
```

Again, I'm diverging from the book slightly. In the book, the authors are using an `hx-delete` attribute on the submit button itself (and then targeting the `body` tag). But, to me, it seemed easier to just navigate to the `index.deleteMany.cfm` file, perform the delete, and then redirect back to the index page.

My approach incurs an additional request to the server; but, my approach also feels less "clever", which I always appreciate. Plus, by redirecting to a separate page, it gives me a clear place to render an error message should I ever need to (not that I am in this implementation).

Ultimately, I'm taking the user to the following deletion page, where I perform the multi-contact delete, and then redirect the user back to the search page. To help the user maintain context in the pagination, I'm passing through the search parameters; and then using them in the redirection as well. This way, if you multi-delete contacts on the 3rd search results page, I bring you back to the 3rd search results page:

```cfm
<cfscript>

	param name="form.contactIDs" type="array" default=[];
	param name="form.q" type="string" default="";
	param name="form.page" type="string" default="";
	param name="form.pageSize" type="string" default="";

	for ( id in form.contactIDs ) {

		contactModel.deleteByFilter( id = id );

	}

	goto(
		"index.cfm" &
		"?flash=contact.deletedMany" &
		"&q=#encodeForUrl( form.q )#" &
		"&page=#encodeForUrl( form.page )#" &
		"&pageSize=#encodeForUrl( form.pageSize )#"
	);

</cfscript>
```

Just because I have HTMX, it doesn't mean that I have to HTMX'ify _all the things_. Part of what makes HTMX so powerful is that is builds on the native web platform. And sometimes that means doing full page redirects.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "Bulk Delete".


[hypermedia-chapter]: https://hypermedia.systems/more-htmx-patterns/#_bulk_delete
