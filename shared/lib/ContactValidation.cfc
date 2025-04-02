component {

	/**
	* I test and normalize the given input.
	*/
	public string function testEmail( string input = "" ) {

		input = input.trim().lcase();

		if ( ! input.len() ) {

			throw(
				type = "Model.Empty",
				message = "Email cannot be empty."
			);

		}

		if ( input.len() > 75 ) {

			throw(
				type = "Model.TooLong",
				message = "Email must be less than 75 characters."
			);

		}

		if ( ! input.reFind( "^[^@]+@[^.]+(\.[^.]+)+$" ) ) {

			throw(
				type = "Model.Invalid",
				message = "Email must be properly formatted."
			);

		}

		return input;

	}


	/**
	* I test and normalize the given input.
	*/
	public string function testName( string input = "" ) {

		input = input.trim();

		if ( ! input.len() ) {

			throw(
				type = "Model.Empty",
				message = "Name cannot be empty."
			);

		}

		if ( input.len() > 50 ) {

			throw(
				type = "Model.TooLong",
				message = "Name must be less than 50 characters."
			);

		}

		return input;

	}


	/**
	* I test and normalize the given input.
	*/
	public string function testPhone( string input = "" ) {

		input = input.trim();

		if ( input.len() > 20 ) {

			throw(
				type = "Model.TooLong",
				message = "Phone must be less than 20 characters."
			);

		}

		return input;

	}


	/**
	* I throw a conflict error.
	*/
	public void function throwConflict() {

		throw(
			type = "Model.Conflict",
			message = "A contact with the given email already exists."
		);

	}


	/**
	* I throw a not found error.
	*/
	public void function throwNotFound() {

		throw(
			type = "Model.NotFound",
			message = "The requested contact could not be found."
		);

	}

}
