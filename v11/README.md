
# v11 Iteration

This iteration of the ColdFusion + HTMX application adds the `hx-disabled-elt` attribute to the add and edit forms to disable the submit buttons while the form is being processed. I've also added a `sleep(500)` to these forms so that the disabled state of the button can be seen briefly during processing (otherwise the processing happens too quickly).

As I was experimenting with this attribute, I felt like there was a happy middle ground that was missing. Consider the `hx-disabled-elt` attribute on a form tag. To disable the buttons in the form, I can do this:

`<form hx-disabled-elt="button">`

This works; but, it will disable _all the buttons_ on the _entire page_ during the form processing, not just the buttons within the form.

To limit the scope to the form, we could try to add the `find` keyword:

`<form hx-disabled-elt="find button">`

This will scope the `button` CSS selector to the form; but, it will only find the _first_ matching button. If the form has multiple submit buttons, all the buttons after the first one would remain enabled during the form processing.

To limit the scope to the form but keep the selection broad, we could use traditional CSS techniques, like giving the form a class and then including that class in our global CSS selector:

`<form class="my-form" hx-disabled-elt=".my-form button">`

This would disable _all buttons_ within our form thanks to the `.my-form` scoping.

For the simplicity of the demo, I'm just using the global `button` selector since I don't have any UIs with unrelated buttons strewn around the page. But, I thought it was worth discussing.

I've also opened an [idea discussion][gh-issue] on GitHub, suggesting that new CSS helper like `findall` or `findmany` might be a value-add for this kind of a scenario.

This wasn't a specific step in the Hypermedia Systems book, it was just something I wanted to consider after adding the `hx-sync` to the root element in the last iteration (and the trade-off that double-submissions were no longer inherently handled by the implicit `hx-sync` on each element).

[gh-issue]: https://github.com/bigskysoftware/htmx/discussions/3270
