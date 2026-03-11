@regression @notes @unhappy-path @delete-note @delete
Feature: To test unhappy path for notes/delete-note

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

	Scenario Outline: Deleta a note with invalid id
		Given path 'notes/<noteId>'
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method delete
		Then status <statusCode>
		And match response.message == "<message>"
		Examples:
		| noteId                   | statusCode | message                                                      |
		| 69a9351d2a7dd30298b728df | 404        | No note was found with the provided ID, Maybe it was deleted |
		| a                        | 400        | Note ID must be a valid ID                                   |

	Scenario: Delete a note with no authorization
		#Create note
		* def sampleNote = call read('classpath:com/api/automation/resources/create-note.feature')
		* def noteId = sampleNote.noteId

		#Delete note
		Given path 'notes', noteId
		And headers { Accept: "application/json"}
		When method delete
		Then status 401
		And match response.message == "No authentication token specified in x-auth-token header"

	Scenario Outline: Delete account with invalid authorization
		#Create note
		* def sampleNote = call read('classpath:com/api/automation/resources/create-note.feature')
		* def noteId = sampleNote.noteId

		#Delete note
		Given path 'notes', noteId
		And headers { Accept: "application/json", x-auth-token: "#(<authorization>)" }
		When method delete
		Then status 401
		And match response.message == "<message>"
		Examples:
		| authorization                  | message                                                          |
		| ''                             | No authentication token specified in x-auth-token header         |
		| quqeuequqeuequqeuqe            | Access token is not valid or has expired, you will need to login |
		| 'Basic ' + getToken.authToken  | Access token is not valid or has expired, you will need to login |
		| 'Bearer ' + getToken.authToken | Access token is not valid or has expired, you will need to login |

	Scenario: Delete a note twice
		#Create note
		* def sampleNote = call read('classpath:com/api/automation/resources/create-note.feature')
		* def noteId = sampleNote.noteId
		#Delete note
		Given path 'notes', noteId
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method delete
		Then status 200
		And match response.message == "Note successfully deleted"

		#Delete note
		Given path 'notes', noteId
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method delete
		Then status 404
		And match response.message == "No note was found with the provided ID, Maybe it was deleted"