<cfscript>

	param name="url.q" type="string" default="";
	param name="url.page" type="numeric" default=1;
	param name="url.pageSize" type="numeric" default=20;

	pagination = contactModel.getBySearchPagination(
		keywords = url.q.trim(),
		page = val( url.page ),
		pageSize = val( url.pageSize )
	);
	contacts = pagination.results;
	title = "All Contacts";

</cfscript>

<cfsavecontent variable="body">
<cfoutput>

	<h1>
		Contacts App

		<span
			hx-sync="this:replace"
			hx-get="index.count.cfm"
			hx-trigger="
				revealed,
				contactDeleted from:body
			">
			<!--- Lazy load the contacts length. --->
			(loading count...)
		</span>
	</h1>

	<nav>
		<a href="add.cfm">Add contact</a> |
		<a href="generate.cfm">Generate data</a> |
		<a href="clear.cfm">Clear data</a> |
		<!--- Don't boost the navigation back to the root directory. --->
		<a href="/" hx-boost="false">Back to root</a>
	</nav>

	<hr />

	<div class="search-section">

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
			<label for="search">
				Search contacts:
			</label>
			<input
				id="search"
				type="text"
				name="q"
				value="#encodeForHtmlAttribute( url.q )#"
			/>
			<button type="submit">
				Search
			</button>

			<span class="htmx-indicator">
				Loading....
			</span>

			<div
				hx-target=".search-section"
				hx-select=".search-section"
				hx-swap="show:window:top"

				class="pagination">

				<cfif pagination.hasPrevious>
					<a href="index.cfm?q=#encodeForUrl( url.q )#&page=#( pagination.page - 1 )#&pageSize=#( pagination.pageSize )#">
						&larr; <u>Prev</u>
					</a>
				<cfelse>
					&larr; Prev
				</cfif>

				<cfif pagination.hasNext>
					<a href="index.cfm?q=#encodeForUrl( url.q )#&page=#( pagination.page + 1 )#&pageSize=#( pagination.pageSize )#">
						<u>Next</u> &rarr;
					</a>
				<cfelse>
					Next &rarr;
				</cfif>
			</div>
		</form>

		<div class="search-results">

			<cfif contacts.len()>

				<table>
				<thead>
					<tr>
						<th>
							<!--- Checkboxes. --->
						</th>
						<th scope="col">
							Name
						</th>
						<th scope="col">
							Email
						</th>
						<th>
							<!--- Actions. --->
						</th>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#contacts#" item="contact">
						<tr>
							<td>
								<!--- These are associated with the form below the table. --->
								<input
									form="bulkForm"
									type="checkbox"
									name="contactIDs[]"
									value="#encodeForHtmlAttribute( contact.id )#"
								/>
							</td>
							<td>
								<a href="view.cfm?id=#encodeForUrl( contact.id )#">#encodeForHtml( contact.name )#</a>
							</td>
							<td>
								#encodeForHtml( contact.email )#
							</td>
							<td>
								<a href="edit.cfm?id=#encodeForUrl( contact.id )#">Edit</a>
								<button
									hx-sync="this"
									hx-delete="index.delete.cfm?id=#encodeForUrl( contact.id )#&submitted=true"
									hx-target="closest tr"
									hx-swap="outerHTML"
									class="link-button">
									Delete
								</button>
							</td>
						</tr>
					</cfloop>
				</tbody>
				</table>

				<form
					id="bulkForm"
					method="post"
					action="index.deleteMany.cfm"

					hx-confirm="Are you sure you want to delete the selected contacts?">

					<!---
						Pass through the query and pagination settings so that we can
						re-route to this same page after deletion.
					--->
					<input type="hidden" name="q" value="#encodeForHtmlAttribute( url.q )#" />
					<input type="hidden" name="page" value="#encodeForHtmlAttribute( url.page )#" />
					<input type="hidden" name="pageSize" value="#encodeForHtmlAttribute( url.pageSize )#" />

					<button type="submit">
						Delete Selected Contacts
					</button>
				</form>

				<div
					hx-target="this"
					hx-select=".downloader"
					hx-push-url="false"
					class="downloader">

					<a href="download.cfm?action=start">Download contact list</a>
				</div>

			</cfif>

			<cfif ! contacts.len()>

				<cfif ( url.q.len() || ( pagination.page gt 1 ) )>

					<p class="no-results">
						No contacts match your search.
						<a href="index.cfm">Clear search</a>.
					</p>

				<cfelse>

					<p class="no-results">
						You have no contacts at this time.
						<a href="generate.cfm">Generate some demo data</a>.
					</p>

				</cfif>

			</cfif>

		</div>

	</div>

</cfoutput>
</cfsavecontent>

<cfinclude template="_layout.cfm">
