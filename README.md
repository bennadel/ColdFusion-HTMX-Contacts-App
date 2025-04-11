
# ColdFusion + HTMX Contact App

by [Ben Nadel][bennadel]

In the book, [Hypermedia Systems by Carson Gross][hypermedia-book] (see [my review][blog-4769]), the author walks the reader through the creation of a [simple Web 1.0 application][hypermedia-chapter] that manages a list of contacts. This application is then iteratively enhanced using HTMX. This repository is my attempt to _loosely_ translate that Flask app into a ColdFusion app such that I may gain a better feel for how HTMX can fit into my ColdFusion workflow.

The code in this ColdFusion application should **not** be considered best practices. I'm cutting many corners to try and keep the code simple and straightforward. Please keep this in mind if you look at the implementation.

## Application Iterations

* [v1](./v1/) - the vanilla ColdFusion application.
* [v2](./v2/) - the initial HTMX version with `hx-boost`.
* [v3](./v3/) - adds `hx-delete` to the delete button.
* [v4](./v4/) - adds `hx-get` realtime email validation.
* [v5](./v5/) - adds pagination to contacts list.
* [v6](./v6/) - adds a "load more" button to the contacts list.
* [v7](./v7/) - adds infinite scrolling.
* [v8](./v8/) - adds realtime search.
* [v9](./v9/) - adds `request.htmx` struct based on HTTP headers.
* [v10](./v10/) - adds a loading indicator during search.
* [v11](./v11/) - adds button disabling during form submission.
* [v12](./v12/) - adds lazy-loaded contact count.
* [v13](./v13/) - refactor search layout to use "focus scroll" behavior.
* [v14](./v14/) - adds a delete button to the contacts list.

## Running With CommandBox

This ColdFusion application runs on CommandBox. To run it for yourself, you'll need to install the CommandBox CLI ([using something like Homebrew][homebrew]). Then, simply:

* Run `box` in this directory.
* Run `start` to start the ColdFusion server.
* Navigate to the desired version of the application.

Inside the given version folder, the `index.cfm` page should automatically initialize the ColdFusion application.


[bennadel]: https://www.bennadel.com/

[blog-4769]: https://www.bennadel.com/blog/4769-hypermedia-systems-by-carson-gross.htm "Read article: Hypermedia Systems By Carson Gross"

[homebrew]: https://formulae.brew.sh/formula/commandbox

[hypermedia-book]: https://hypermedia.systems/

[hypermedia-chapter]: https://hypermedia.systems/a-web-1-0-application/
