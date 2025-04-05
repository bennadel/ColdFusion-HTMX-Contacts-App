
# v6 Iteration

This iteration of the ColdFusion + HTMX application updates the basic pagination of the contacts list to include a "load more" button at the bottom of the list. The load more button will use the existing pagination mechanics; and will take the new `<tr>` nodes returned in the paged response and append them to the table.

I don't love that the "load more" button is physically inside the table - this doesn't feel like a semantically correct pattern to me. But, keeping the button in the table makes it easy to both add new rows and to conditionally stop showing the button when there are no more rows to show. Perhaps when I learn more about OOB (out of band) swaps, I'll be able to handle this more elegantly.

I'm leaving the prev/next functionality in place to make this change additive.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "Click To Load".


[hypermedia-chapter]: https://hypermedia.systems/htmx-patterns/#_click_to_load
