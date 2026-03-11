@regression @notes @unhappy-path @get-notes @get
Feature: To test unhappy path for notes/get-notes

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

	Scenario Outline: Get a note with invalid id
		Given path 'notes/<noteId>'
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method get
		Then status <statusCode>
		And match response.message == "<message>"
		Examples:
		| noteId                   | statusCode | message                                                      |
		| 69a9351d2a7dd30298b728df | 404        | No note was found with the provided ID, Maybe it was deleted |
		| a                        | 400        | Note ID must be a valid ID                                   |

	Scenario: Get a note with no authorization
		#Create note
		Given path 'notes'
		And form field title = noteTitle
		And form field description = noteDescription
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method post
		Then status 200
		And match response.message == "Note successfully created"
		And match response.data.title == noteTitle
		And match response.data.description == noteDescription
		And match response.data.category == noteCategory
		And match response.data.user_id == userId
		* def noteId = response.data.id

		#Get note
		Given path 'notes', noteId
		And headers { Accept: "application/json"}
		When method get
		Then status 401
		And match response.message == "No authentication token specified in x-auth-token header"

	Scenario Outline: Get a note with invalid authorization
		#Create note
		Given path 'notes'
		And form field title = noteTitle
		And form field description = noteDescription
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method post
		Then status 200
		And match response.message == "Note successfully created"
		And match response.data.title == noteTitle
		And match response.data.description == noteDescription
		And match response.data.category == noteCategory
		And match response.data.user_id == userId
		* def noteId = response.data.id

		#Get note
		Given path 'notes', noteId
		And headers { Accept: "application/json", x-auth-token: "#(<authorization>)" }
		When method get
		Then status 401
		And match response.message == "<message>"
		Examples:
		| authorization                  | message                                                          |
		| ''                             | No authentication token specified in x-auth-token header         |
		| quqeuequqeuequqeuqe            | Access token is not valid or has expired, you will need to login |
		| 'Basic ' + getToken.authToken  | Access token is not valid or has expired, you will need to login |
		| 'Bearer ' + getToken.authToken | Access token is not valid or has expired, you will need to login |

	Scenario: Get all notes with no authorization
		Given path 'notes'
		And headers { Accept: "application/json"}
		When method get
		Then status 401
		And match response.message == "No authentication token specified in x-auth-token header"

	Scenario Outline: Get all notes with invalid authorization
		Given path 'notes'
		And headers { Accept: "application/json", x-auth-token: "#(<authorization>)" }
		When method get
		Then status 401
		And match response.message == "<message>"
		Examples:
			| authorization                  | message                                                          |
			| ''                             | No authentication token specified in x-auth-token header         |
			| quqeuequqeuequqeuqe            | Access token is not valid or has expired, you will need to login |
			| 'Basic ' + getToken.authToken  | Access token is not valid or has expired, you will need to login |
			| 'Bearer ' + getToken.authToken | Access token is not valid or has expired, you will need to login |