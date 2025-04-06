
# v4 Iteration

This iteration of the ColdFusion + HTMX application adds the realtime email validation to the Add / Edit contact form. It does this by including an `hx-get` on the email input field which hits a new endpoint specifically created for email validation.

Since the realtime validation works by replacing the contents of a `<span>` on the page, it works by returning an empty string if the given email is available; or, an error string if the email is already taken by another contact. In both cases, the response HTML of the validation request is transcluded into the rendered page.

Here's the updated form field for the email:

```cfml
<p class="form-field">
	<label for="email">
		Email:
	</label>
	<input
		id="email"
		type="text"
		name="email"
		value="#encodeForHtmlAttribute( form.email )#"

		hx-get="validateEmail.cfm"
		hx-trigger="input delay:200ms"
		hx-target="next .inline-error"
	/>
	<span class="inline-error">
		<!--- Populated by the HTMX call above. --->
	</span>
</p>
```

In the book, they use the `change` event within the `hx-trigger` attribute. But, I don't quite understand this choice. As such, I've opted to use the `input` event instead as I _believe_ it accomplishes the same outcome with less complexity.

I've opened a [discussion on the GitHub forum][gh-discussion] to ask about this `input` vs. `change` event selection. I've seen this pattern (using the `change` event) used in more than just this book, even for realtime validation. As such, I wonder if there's some mechanics that I'm just not understanding at this time.

> **Update**: In the GitHub discussion, I was told that using the `input` is fine; and that the `input` event is being used more frequently in the HTMX documentation now.

On the **add** contact page, the URL doesn't include a contact ID since we're adding a new contact. However, on the **edit** page, I'm including the current contact ID in the `hx-get` attribute so that I can ignore email conflicts on the given record:

* Add: `hx-get="validateEmail.cfm"`
* Edit: `hx-get="validateEmail.cfm?id=#contact.id#"`

> **Aside**: I originally tried using the `hx-include` attribute to include the rest of the form inputs along with the `hx-get` request. However, on the edit page, the contact ID is being defined in the form's `action` attribute; and parameters encoded into the `action` attribute don't seem to get included by the `hx-include` directive.

As an aside, this inline error rendering felt like a good place to progressively enhance with the `:has()` CSS selector. In my approach, the `<span class="inline-error">` starts out as an inline element with no margins and no inherent size. However, if it contains any other element, I'm using `:has(*)` to change the span to a _block_ element with some top margin:

```css
.inline-error {
	color: red ;
	font-size: 80% ;
}
.inline-error:has(*) {
	display: block ;
	margin-top: 0.5rem ;
}
```

Then, in my email validation endpoint, the error message - if any - is returned in another span:

```cfml
<span class="inline-error-content">
	This email address is already taken.
</span>
```

For browsers that don't support `:has()`, this is just two inline span tags. However, for browsers that _do_ support `:has()`, the error message will be rendered as a block element with some additional breathing room.

See [relevant chapter in Hypermedia Systems][hypermedia-chapter]. It's the section labeled, "Next Steps: Validating Contact Emails".


[gh-discussion]: https://github.com/bigskysoftware/htmx/discussions/3265

[hypermedia-chapter]: https://hypermedia.systems/htmx-patterns/#_next_steps_validating_contact_emails
