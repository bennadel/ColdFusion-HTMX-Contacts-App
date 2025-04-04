<cfscript>

	param name="url.q" type="string" default="";

	contacts = contactModel.getBySearch( url.q.trim() );
	title = "All Contacts";

</cfscript>

<cfsavecontent variable="body">
<cfoutput>

	<h1>
		Contacts App (HTMX + ColdFusion)
	</h1>

	<form method="get" class="linear-form">
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
	</form>

	<cfif contacts.len()>

		<table>
		<thead>
			<tr>
				<th scope="col">
					Name
				</th>
				<th scope="col">
					Phone
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
						<a href="view.cfm?id=#encodeForUrl( contact.id )#">#encodeForHtml( contact.name )#</a>
					</td>
					<td>
						#encodeForHtml( contact.phone )#
					</td>
					<td>
						#encodeForHtml( contact.email )#
					</td>
					<td>
						<a href="edit.cfm?id=#encodeForUrl( contact.id )#">Edit</a>
					</td>
				</tr>
			</cfloop>
		</tbody>
		</table>

	</cfif>

	<cfif ! contacts.len()>

		<cfif url.q.len()>

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

	<p>
		<a href="add.cfm">Add contact</a>
	</p>

</cfoutput>
</cfsavecontent>

<cfinclude template="_layout.cfm">
