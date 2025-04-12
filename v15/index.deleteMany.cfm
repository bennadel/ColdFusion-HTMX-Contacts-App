<cfscript>

	param name="form.contactIDs" type="array" default=[];
	param name="form.q" type="string" default="";
	param name="form.page" type="string" default="";
	param name="form.pageSize" type="string" default="";

	for ( id in form.contactIDs ) {

		contactModel.deleteByFilter( id = id );

	}

	goto(
		"index.cfm" &
		"?flash=contact.deletedMany" &
		"&q=#encodeForUrl( form.q )#" &
		"&page=#encodeForUrl( form.page )#" &
		"&pageSize=#encodeForUrl( form.pageSize )#"
	);

</cfscript>
