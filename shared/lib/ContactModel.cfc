component {

	/**
	* I initialize the contact model.
	*/
	public void function init() {

		variables.validation = new ContactValidation();

		// Since the contact model will be shared across the various implementations of
		// this demo app, we're going to cache the contact data in the server scope and
		// then re-use the data in each app context.
		// --
		// Note: Normally with shared data, I would be LOCKING access to the data so that
		// we don't run into any synchronization issues. I'd also not return the direct
		// object references to the calling context (for fear of direct manipulation
		// from outside the bounds of the model encapsulation). However, since this is
		// just a demo app, I'm going to forego this level of correctness and focus on the
		// HTMX parts.
		variables.cacheKey = "htmx-contacts-data";
		server[ cacheKey ] = ( server[ cacheKey ] ?: [] );

	}

	// ---
	// PUBLIC METHODS.
	// ---

	/**
	* I create a new model.
	*/
	public numeric function create(
		required string name,
		required string phone,
		required string email
		) {

		name = validation.testName( name );
		phone = validation.testPhone( phone );
		email = validation.testEmail( email );

		assertEmailIsAvailable( email );

		var id = nextId();

		server[ cacheKey ].append({
			id,
			name,
			phone,
			email
		});

		updateSort();

		return id;

	}


	/**
	* I delete the models that matches the given filter.
	*/
	public void function deleteByFilter(
		numeric id,
		string name,
		string email,
		string phone
		) {

		server[ cacheKey ] = server[ cacheKey ].filter(
			( element ) => {

				// Keep the elements that DON'T MATCH filters.
				return ! (
					( isNull( id ) || ( element.id == id ) ) &&
					( isNull( name ) || ( element.name == name ) ) &&
					( isNull( email ) || ( element.email == email ) ) &&
					( isNull( phone ) || ( element.phone == phone ) )
				);

			}
		);

	}


	/**
	* I generate demo model data for the application.
	*/
	public void function generateDemoData() {

		create( "Emily Thomas",    "555-1111",  "emily.thomas@example.com" );
		create( "David Mitchell",  "555-2222",  "david.mitchell@example.com" );
		create( "Diva Jones",      "555-3333",  "diva.jones@example.com" );
		create( "Dylan Lee",       "555-3333",  "dylan.lee@example.com" );
		create( "Riley Smith",     "555-4444",  "riley.smith@example.com" );
		create( "Joseph Jackson",  "555-5555",  "joseph.jackson@example.com" );
		create( "David Jones",     "555-6666",  "david.jones@example.com" );
		create( "Ellie Mitchell",  "555-7777",  "ellie.mitchell@example.com" );
		create( "Ethan Scott",     "555-8888",  "ethan.scott@example.com" );
		create( "Luna Rodriguez",  "555-9999",  "luna.rodriguez@example.com" );
		create( "Nova Gonzalez",   "555-0000",  "nova.gonzalez@example.com" );

	}


	/**
	* I get the model with the given identifier.
	*/
	public struct function get( required numeric id ) {

		var results = getByFilter( id = id );

		if ( ! results.len() ) {

			validation.throwNotFound();

		}

		return results.first();

	}


	/**
	* I get the models that match the given filters.
	*/
	public array function getByFilter(
		numeric id,
		string name,
		string email,
		string phone
		) {

		return server[ cacheKey ].filter(
			( element ) => {

				// Keep the elements that DO MATCH filters.
				return (
					( isNull( id ) || ( element.id == id ) ) &&
					( isNull( name ) || ( element.name == name ) ) &&
					( isNull( email ) || ( element.email == email ) ) &&
					( isNull( phone ) || ( element.phone == phone ) )
				);

			}
		);

	}


	/**
	* I get the models that match the given keyword search.
	*/
	public array function getBySearch( required string keywords ) {

		if ( ! keywords.len() ) {

			return server[ cacheKey ];

		}

		return server[ cacheKey ].filter(
			( element ) => {

				return (
					element.name.findNoCase( keywords ) ||
					element.email.findNoCase( keywords ) ||
					element.phone.findNoCase( keywords )
				);

			}
		);

	}


	/**
	* I get the page of models that match the given keyword search.
	*
	* Note: This pagination method was created a separate method from the one above
	* because it was added in a later application iteration and I don't want to break the
	* earlier versions of the application.
	*/
	public struct function getBySearchPagination(
		required string keywords,
		numeric page = 1,
		numeric pageSize = 5
		) {

		page = max( fix( page ), 1 );
		pageSize = min( max( fix( pageSize ), 1 ), 50 );

		var results = getBySearch( keywords );
		var offset = ( ( ( page - 1 ) * pageSize ) + 1 );

		// If we've gone beyond the bounds of the results, return the null-set.
		if ( offset > results.len() ) {

			return {
				results: [],
				page: page,
				pageSize: pageSize,
				hasPrevious: false,
				hasNext: false
			};

		}

		var length = min( pageSize, ( results.len() - offset + 1 ) );

		return {
			results: results.slice( offset, length ),
			page: page,
			pageSize: pageSize,
			hasPrevious: ( page > 1 ),
			hasNext: ( length == pageSize )
		};

	}


	/**
	* I update the model with the given identifier.
	*/
	public void function update(
		required numeric id,
		string name,
		string phone,
		string email
		) {

		var model = get( id );

		name = isNull( name )
			? model.name
			: validation.testName( name )
		;
		phone = isNull( phone )
			? model.phone
			: validation.testPhone( phone )
		;
		email = isNull( email )
			? model.email
			: validation.testEmail( email )
		;

		assertEmailIsAvailable( email, model.id );

		// Note: since this is cached data, we can just update the model directly.
		model.name = name;
		model.phone = phone;
		model.email = email;

		updateSort();

	}

	// ---
	// PRIVATE METHODS.
	// ---

	/**
	* I test to see if the given email is already in use and throw an error if so.
	*/
	private void function assertEmailIsAvailable(
		required string email,
		numeric excludingId = 0
		) {

		var existing = getByFilter( email = email );

		if ( ! existing.len() ) {

			return;

		}

		if ( existing.first().id == excludingId ) {

			return;

		}

		validation.throwConflict();

	}


	/**
	* I return the next ID to use during model creation.
	*/
	private numeric function nextId() {

		var maxID = 0;

		for ( var model in server[ cacheKey ] ) {

			maxID = max( maxID, model.id );

		}

		return ++maxID;

	}


	/**
	* I update the sort after mutations so that we don't have to sort the entries on read.
	*/
	private void function updateSort() {

		server[ cacheKey ].sort(
			( a, b ) => {

				if ( a.name != b.name ) {

					return compareNoCase( a.name, b.name );

				}

				return compare( a.email, b.email );

			}
		);

	}

}
