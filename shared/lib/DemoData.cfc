component {

	/**
	* I return a collection of sample contacts with name, phone, and email.
	*/
	public array function getContacts() {

		return getNames().map(
			( name ) => {

				return {
					name: name,
					phone: generatePhone(),
					email: generateEmail( name )
				};

			}
		);

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I generate an email address from the given name (assumed to be two tokens).
	*/
	private string function generateEmail( required string name ) {

		return lcase( "#name#@example.com" ).replace( " ", "." );

	}


	/**
	* I generate a random 10 digit phone number.
	*/
	private string function generatePhone() {

		var a = randRange( 111, 999, "sha1prng" );
		var b = randRange( 111, 999, "sha1prng" );
		var c = randRange( 1111, 9999, "sha1prng" );

		return "(#a#) #b#-#c#";

	}


	/**
	* I return a set of sample names. All names are two tokens.
	*/
	private array function getNames() {

		return [
			"Emily Thomas",
			"David Mitchell",
			"Dylan Lee",
			"Riley Smith",
			"Joseph Jackson",
			"David Jones",
			"Ellie Mitchell",
			"Ethan Scott",
			"Luna Rodriguez",
			"Nova Gonzalez",
			"Michael Williams",
			"Lincoln White",
			"Benjamin Davis",
			"Grayson Miller",
			"Carter Roberts",
			"Bella King",
			"Owen Nelson",
			"Hudson Nguyen",
			"Logan Nelson",
			"Audrey Baker",
			"Daniel Smith",
			"Asher Lopez",
			"Hazel Wilson",
			"Zoe Moore",
			"Charles Rivera",
			"Sebastian King",
			"Eleanor Rivera",
			"Lillian Nguyen",
			"Sebastian Jones",
			"Samuel Roberts",
			"Hannah Perez",
			"Alexander Martin",
			"Bella Perez",
			"Nova Taylor",
			"Violet Hall",
			"Lucy Hill",
			"Dylan White",
			"Eleanor Young",
			"Owen Baker",
			"Hannah Garcia",
			"Elijah Anderson",
			"Christopher Taylor",
			"Harper Jones",
			"Harper Thompson",
			"Sofia Clark",
			"Maverick Allen",
			"Ava Smith",
			"Bella Torres",
			"Avery Williams",
			"Alexander Thomas",
			"Layla Young",
			"Leah Hernandez",
			"Dylan Wright",
			"Leo Rivera",
			"Emilia Rivera",
			"Everly Jackson",
			"Hannah Young",
			"Anthony Roberts",
			"Nora Johnson",
			"Ellie Harris",
			"Violet Hill",
			"Mia Harris",
			"Elijah Perez",
			"Owen Green",
			"Luna Johnson",
			"Joseph Jones",
			"Violet Adams",
			"Lily Davis",
			"Zoe Williams",
			"Isabella Wilson",
			"Jack Clark",
			"Camila Roberts",
			"Hazel Wright",
			"Ava Allen",
			"Daniel Ramirez",
			"Leo Torres",
			"Lucas Young",
			"Thomas Young",
			"William Wright",
			"Joseph Moore",
			"Josiah Nguyen",
			"Jack Perez",
			"James Allen",
			"Zoe Harris",
			"Isabella Smith",
			"Leah Roberts",
			"Hazel Baker",
			"Aurora Torres",
			"Michael Young",
			"Emma Harris",
			"Charles Miller",
			"Maverick Anderson",
			"Lillian Smith",
			"Addison Adams",
			"Layla Robinson",
			"Levi Sanchez",
			"Kath Day",
			"Kim Day",
			"Sharon Strzelecki",
			"Kel Knight"
		];

	}

}
