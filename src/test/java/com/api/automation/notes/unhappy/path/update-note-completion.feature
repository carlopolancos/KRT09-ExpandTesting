@regression @notes @unhappy-path @update-note-completion @patch
Feature: To test unhappy path for notes/update-note-completion

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

	Scenario: Update note completion with no completed field
		Given path 'notes', noteId
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method patch
		Then status 400
		And match response.message == "Note completed status must be boolean"

	Scenario Outline: Update note completion with invalid completed field
		Given path 'notes', noteId
		And form field completed = <noteCompleted>
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method patch
		Then status 400
		And match response.message == "Note completed status must be boolean"
		Examples:
		| noteCompleted |
		| ''            |
		| 'tru'         |

	Scenario: Update note completion with no authorization
	    Given path 'notes', noteId
		And form field completed = true
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded"}
		When method patch
		Then status 401
		And match response.message == "No authentication token specified in x-auth-token header"

	Scenario Outline: Update note completion with invalid authorization
		Given path 'notes', noteId
		And form field completed = true
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(<authorization>)" }
		When method patch
		Then status 401
		And match response.message == "<message>"
		Examples:
		| authorization                  | message                                                          |
		| ''                             | No authentication token specified in x-auth-token header         |
		| quqeuequqeuequqeuqe            | Access token is not valid or has expired, you will need to login |
		| 'Basic ' + getToken.authToken  | Access token is not valid or has expired, you will need to login |
		| 'Bearer ' + getToken.authToken | Access token is not valid or has expired, you will need to login |