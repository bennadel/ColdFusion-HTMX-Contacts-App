
# v5 Iteration

This iteration of the ColdFusion + HTMX application adds basic pagination to the list of contacts. The pagination is driven by a `page` and `pageSize` parameters. So as not to break the previous iterations of the application (which did not using pagination), I've created a new search method on the model: `getBySearchPagination()`. It is not that robust; and merely makes sure that you don't go beyond the bounds of the results.

Since the application is already being augmented via `hx-boost`, there's nothing else to do to get this to feel snappy.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "Another Application Improvement: Paging".


[hypermedia-chapter]: https://hypermedia.systems/htmx-patterns/#_another_application_improvement_paging
