<cfscript>

	param name="url.id" type="numeric";

	contact = contactModel.get( val( url.id ) );
	title = contact.name;

</cfscript>

<cfsavecontent variable="body">
<cfoutput>

	<h1>
		#encodeForHtml( title )#
	</h1>

	<dl>
		<div>
			<dt>
				Phone:
			</dt>
			<dd>
				<cfif contact.phone.len()>
					#encodeForHtml( contact.phone )#
				<cfelse>
					<em>None provided.</em>
				</cfif>
			</dd>
		</div>
		<div>
			<dt>
				Email:
			</dt>
			<dd>
				#encodeForHtml( contact.email )#
			</dd>
		</div>
	</dl>

	<p>
		<a href="edit.cfm?id=#encodeForUrl( contact.id )#">Edit</a> or
		<a href="index.cfm">Go back</a>
	</p>

</cfoutput>
</cfsavecontent>

<cfinclude template="_layout.cfm">
