
# v7 Iteration

This iteration of the ColdFusion + HTMX application updates the "load more" button at the bottom of the list to use the `revealed` synthetic event. This way, any time the button is in the browser viewport, it will automatically trigger a load of additional rows. This gives us an "infinite scroll" experience with almost no changes to the core mechanics of the pagination.

Again, I'm leaving the prev/next functionality in place to make this change additive.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "Infinite Scroll".


[hypermedia-chapter]: https://hypermedia.systems/htmx-patterns/#_infinite_scroll
