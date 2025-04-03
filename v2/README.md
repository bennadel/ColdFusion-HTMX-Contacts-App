
# v2 Iteration

This iteration of the ColdFusion + HTMX application installs the htmx JavaScript library and adds `hx-boost` to the `<body>` tag. This directive automatically intercepts the link and form posts triggered within the current page and implements them via AJAX, swapping the entire contents of the page (less the `<head>`) with the ColdFusion server response.

Above and beyond what happens in the book, I also had to override the error handling configuration. In this version of the application, I'm returning `422` status codes (Unprocessible Entity) for model validation errors. By default, htmx ignores non-2xx responses; which means that, by default, our `422` responses were being ignored. I had to explicitly tell htmx to execute a `swap` on `422`:

```js
htmx.config.responseHandling = [
	{ code: "204",    swap: false },
	{ code: "[23]..", swap: true },

	// Adding this one to allow 404 responses to be merged into the page.
	{ code: "404",    swap: true, error: true },
	// Adding this one to allow 422 responses to be merged into the page.
	{ code: "422",    swap: true },

	{ code: "[45]..", swap: false, error: true },
	{ code: "...",    swap: true }
];
```

I've also added a configuration to tell it to swap on `404` (Not Found) errors. This isn't immediately relevant in this application. However, if you view a contact in a new browser tab, and then delete that contact, attempting to view the contact in the original browser tab will result in a `404` response. I think it makes sense to render this error to the page.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter].


[hypermedia-chapter]: https://hypermedia.systems/htmx-patterns/
