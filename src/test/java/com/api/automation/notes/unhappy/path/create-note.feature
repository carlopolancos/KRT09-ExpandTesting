@regression @notes @unhappy-path @create-note @post
Feature: To test unhappy path for notes/create-note

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
		And path 'notes'

	Scenario Outline: Create a note with invalid title
		Given form field title = "<noteTitle>"
		And form field description = noteDescription
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method post
		Then status 400
		And match response.message == "Title must be between 4 and 100 characters"
		Examples:
		| noteTitle |
		| ''        |
		| not       |

	Scenario: Create a note with no title parameters
		And form field description = noteDescription
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method post
		Then status 400
		And match response.message == "Title must be between 4 and 100 characters"

	Scenario Outline: Create a note with invalid description
		Given form field title = noteTitle
		And form field description = "<noteCategory>"
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method post
		Then status 400
		And match response.message == "Description must be between 4 and 1000 characters"
		Examples:
		| noteCategory |
		| ''           |
		| not          |

	Scenario: Create a note with no description parameters
		Given form field title = noteTitle
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method post
		Then status 400
		And match response.message == "Description must be between 4 and 1000 characters"

	Scenario Outline: Create a note with invalid description
		Given form field title = noteTitle
		And form field description = noteDescription
		And form field category = "<noteCategory>"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method post
		Then status 400
		And match response.message == "Category must be one of the categories: Home, Work, Personal"
		Examples:
		| noteCategory |
		| ''           |
		| Homee        |

	Scenario: Create a note with no category parameters
		Given form field title = noteTitle
		And form field description = noteDescription
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method post
		Then status 400
		And match response.message == "Category must be one of the categories: Home, Work, Personal"

	Scenario: Delete note with no authorization
		Given form field title = noteTitle
		And form field description = noteDescription
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded"}
		When method post
		Then status 401
		And match response.message == "No authentication token specified in x-auth-token header"

	Scenario Outline: Delete account with invalid authorization
		Given form field title = noteTitle
		And form field description = noteDescription
		And form field category = noteCategory
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(<authorization>)" }
		When method post
		Then status 401
		And match response.message == "<message>"
		Examples:
		| authorization                  | message                                                          |
		| ''                             | No authentication token specified in x-auth-token header         |
		| quqeuequqeuequqeuqe            | Access token is not valid or has expired, you will need to login |
		| 'Basic ' + getToken.authToken  | Access token is not valid or has expired, you will need to login |
		| 'Bearer ' + getToken.authToken | Access token is not valid or has expired, you will need to login |