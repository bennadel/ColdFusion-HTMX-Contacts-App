
# v13 Iteration

This iteration of the ColdFusion + HTMX application refactors the search layout now that I've learned about the [focus scroll feature][focus-scroll] of `hx-swap`. Up till now, I've been trying to be surgical in my selection and swapping during the search results rendering because I was afraid to disrupt the search-input focus. But, it turns out that HTMX will _maintain the focus_ of the currently-focused input during a swap as long as the input has an `id` attribute (that holds consistently across the swap).

What this means is that I can actually wrap the entire search module - including the form, pagination links, and results table - inside a common container:

```cfml
<div class="search-section">

	<form>
		<input />
		<nav />
	</form>
	<table />

</div>
```

Then, I can swap-out this common container for all the main interactions:

* Form submissions.
* Active search while typing (thanks to the "focus scroll").
* Pagination.

Also, I was able to move the active search off of the `input` and simply add it as an additional `hx-trigger` on the form itself. Here's my new form:

```cfml
<form
	method="get"

	hx-trigger="
		submit,
		input from:find input delay:200ms
	"
	hx-target=".search-section"
	hx-select=".search-section"
	hx-swap="show:window:top"

	class="linear-form">

	<!--- other stuff --->
</form>
```

Notice that the `hx-boost`'ed form now responds to both the natural `submit` event and to the active search `input from:find input`. Then, from the response, we're selecting the `.search-section`, our common container, and swapping it. The `hx-swap` directive tells HTMX to scroll to the top of the window (like a normal boosted operation). Note that the default `hx-swap` behavior is to scroll to the top of the `hx-target`.

My pagination is also using a similar tactic:

```cfml
<div
	hx-target=".search-section"
	hx-select=".search-section"
	hx-swap="show:window:top"

	class="pagination">

	<a href="...">Prev</a>
	<a href="...">Next</a>
</div>
```

Again, we're using the `hx-target` and `hx-select` to brute-force swap the entire search area. Note that these attributes are being inherited by both the prev and next pagination links and therefore don't have to be duplicated within both links.

I think this is going to make some of the more dynamic interactions a lot easier if I don't have to worry about input focus (as long as the input has a consistent `id` on it). This seems like a really handy behavior - I'm surprised it isn't more front-and-center in the public discourse. Hopefully I'm not missing something obvious.

> **Aside**: Note that the `value` of the focused input still gets updated based on the server response. So, even though the focus is being maintained across the `hx-swap`, it's possible that the input value will suddenly change out from under the user.


[focus-scroll]: https://htmx.org/attributes/hx-swap/#focus-scroll
