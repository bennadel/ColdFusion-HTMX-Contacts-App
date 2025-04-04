
# v3 Iteration

This iteration of the ColdFusion + HTMX application adds the `hx-delete` action attribute to the Delete Contact button on the Edit page. This removes the need to have the button wrapped in a `<form>` tag; and, turns the button itself into a hypermedia control.

This is the feature of HTMX that I care for the least. Using the `DELETE` method makes working with ColdFusion harder. In CFML, it's easy to differentiate between a `GET` and a `POST` because they populate two different scopes: `url` and `form`, respectively. As such, including `submitted` flags and verifying XSRF (Cross-Site Request Forgery) tokens, for example, is fairly easy.

Once we introduce the `DELETE` verb, life gets harder. With a `DELETE` request, there is currently no _request body_. Which means that all form values are submitted in the URL and therefore populate the `url` scope. As such, if we wanted to check for something like a `submitted` flag, we'd have to do so in the `url` scope (not the traditional `form` scope). This, in turn, makes the attack surface a little easier to access.

Now, the counter-argument to this concern is that forms don't currently support `DELETE`; so, such a request would have to be made via JavaScript; and, a properly configured CORS (Cross Origin Resource Sharing) setting should prevent a malicious off-site `DELETE` request. But, this feels like a coincidental alleviation, not an intentional one. After all, if a browser were to introduce ` method="DELETE"` support, then suddenly this would be an issue.

To ensure the proper HTTP request, I'm now having to explicitly check to see if the incoming request was performed via `DELETE`. This is doable; but, it requires more code than simply checking to see if a value was populated in the `form` scope.

If we had a more robust router in the demo app, that would only route `DELETE` requests here, then that might be less of an issue. But, in my app, I use a common post-back pattern, which means that the delete-contact page is also capable of rendering a form (and should also respond to a `GET` request).

Another issue with this is that custom hypermedia controls don't play with with `hx-boost`, which we added in the previous iteration. As such, we have to add `hx-target` and `hx-push-url` attributes to the button. Ultimately, our button ends up looking like this:

```html
<button
	hx-delete="delete.cfm?id=#contact.id#&submitted=true"
	hx-target="body"
	hx-push-url="true"
	hx-confirm="Are you sure you want to delete this contact?"
	type="button">
	Delete Contact
</button>
```

Long story short, this is not a real value-add feature of the HTMX framework for me. I understand how it makes sense academically; but, I don't feel like it makes sense practically in the way I think about application development. Frankly, I think it makes the code more complicated and cuts against the grain of how CFML wants to work.

> **Aside**: To see how the `hx-delete` works with error responses, I've gone back and added logic to prevent deletes on any contact whose first name is "Diva" (ex, "Diva Jones"). Since this kind of a test generally makes sense, I've added it to the previous iterations as well.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "A Second Step: Deleting Contacts With HTTP DELETE".


[hypermedia-chapter]: https://hypermedia.systems/htmx-patterns/
