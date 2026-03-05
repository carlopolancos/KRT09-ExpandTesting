@regression @users @unhappy-path @update-user @patch
Feature: To test unhappy path for users/profile (patch)

	Background: To set base
		#Define user info
		* def userName = "carlo"
		* def userEmail = "carlojamespolancos1210@gmail.com"
		* def userPassword = "passSampleword"
		* def getToken = callonce read('classpath:com/api/automation/resources/get-token.feature')
		Given url _url

	Scenario: Update user info with invalid name
		And path 'users/profile'
		And form field name = "cac"
		And form field phone = "0987654321"
		And form field company = "Example Company"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(getToken.authToken)" }
		When method patch
		Then status 400
		And match response.message == "User name must be between 4 and 30 characters"

	Scenario: Update user info with invalid phone
		And path 'users/profile'
		And form field name = "carlo"
		And form field phone = "aaaaaaaaaa"
		And form field company = "Example Company"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(getToken.authToken)" }
		When method patch
		Then status 400
		And match response.message == "Phone number should be between 8 and 20 digits"

	Scenario: Update user info with invalid company
		And path 'users/profile'
		And form field name = "carlo"
		And form field phone = "0987654321"
		And form field company = "Exa"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(getToken.authToken)" }
		When method patch
		Then status 400
		And match response.message == "Company name must be between 4 and 30 characters"

	Scenario: Update user info with no authorization
		And path 'users/profile'
		And form field name = "carlo"
		And form field phone = "0987654321"
		And form field company = "Example Company"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded"}
		When method patch
		Then status 401
		And match response.message == "No authentication token specified in x-auth-token header"

	Scenario Outline: Update user info with invalid authorization
		And path 'users/profile'
		And form field name = "carlo"
		And form field phone = "0987654321"
		And form field company = "Example Company"
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