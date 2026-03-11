@regression @notes @unhappy-path @update-note @put
Feature: To test unhappy path for notes/update-note

	Background: To set base
		#Define note info
		* def noteTitle = "KRT09-ExpandTesting"
		* def noteDescription = "Expand testing expand testing expand testing expand testing."
		* def noteCategory = "Home"
		#Category can only be: Home, Work or Personal
		* def getToken = callonce read('classpath:com/api/automation/resources/get-token.feature')
		* def authToken = getToken.authToken
		* def userId = getToken.userId
		Given url _url

		#Create note
		* def sampleNote = callonce read('classpath:com/api/automation/resources/create-note.feature')
		* def noteId = sampleNote.noteId

	Scenario: Update note with no title field
		Given path 'notes', noteId
		And form field description = noteDescription
		And form field completed = true
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method put
		Then status 400
		And match response.message == "Title must be between 4 and 100 characters"

	Scenario Outline: Update note with invalid title field
		Given path 'notes', noteId
		And form field title = "<noteTitle>"
		And form field description = noteDescription
		And form field completed = true
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method put
		Then status 400
		And match response.message == "Title must be between 4 and 100 characters"
		Examples:
			| noteTitle |
			| ''        |
			| not       |

	Scenario: Update note with no description field
		Given path 'notes', noteId
		And form field title = noteTitle
		And form field completed = true
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method put
		Then status 400
		And match response.message == "Description must be between 4 and 1000 characters"

	Scenario Outline: Update note with invalid description field
		Given path 'notes', noteId
		And form field title = noteTitle
		And form field description = "<noteDescription>"
		And form field completed = true
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method put
		Then status 400
		And match response.message == "Description must be between 4 and 1000 characters"
		Examples:
			| noteDescription |
			| ''              |
			| not             |

	Scenario: Update note with no completed field
		Given path 'notes', noteId
		And form field title = noteTitle
		And form field description = noteDescription
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method put
		Then status 400
		And match response.message == "Note completed status must be boolean"

	Scenario Outline: Update note with invalid completed field
		Given path 'notes', noteId
		And form field title = noteTitle
		And form field description = noteDescription
		And form field completed = <noteCompleted>
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method put
		Then status 400
		And match response.message == "Note completed status must be boolean"
		Examples:
		| noteCompleted |
		| ''            |
		| 'tru'         |

	Scenario: Update note with no category field
		Given path 'notes', noteId
		And form field title = noteTitle
		And form field description = noteDescription
		And form field completed = true
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method put
		Then status 400
		And match response.message == "Category must be one of the categories: Home, Work, Personal"

	Scenario Outline: Update note with invalid category field
		Given path 'notes', noteId
		And form field title = noteTitle
		And form field description = noteDescription
		And form field completed = true
		And form field category = "<noteCategory>"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method put
		Then status 400
		And match response.message == "Category must be one of the categories: Home, Work, Personal"
		Examples:
		| noteCategory |
		| ''           |
		| not          |

	Scenario: Update note with no authorization
	    Given path 'notes', noteId
		And form field title = noteTitle
		And form field description = noteDescription
		And form field category = noteCategory
		And form field completed = true
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded"}
		When method put
		Then status 401
		And match response.message == "No authentication token specified in x-auth-token header"

	Scenario Outline: Update note with invalid authorization
		Given path 'notes', noteId
		And form field title = noteTitle
		And form field description = noteDescription
		And form field category = noteCategory
		And form field completed = true
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(<authorization>)" }
		When method put
		Then status 401
		And match response.message == "<message>"
		Examples:
			| authorization                  | message                                                          |
			| ''                             | No authentication token specified in x-auth-token header         |
			| quqeuequqeuequqeuqe            | Access token is not valid or has expired, you will need to login |
			| 'Basic ' + getToken.authToken  | Access token is not valid or has expired, you will need to login |
			| 'Bearer ' + getToken.authToken | Access token is not valid or has expired, you will need to login |