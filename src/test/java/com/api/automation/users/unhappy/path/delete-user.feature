@regression @users @unhappy-path @delete-user @delete
Feature: To test unhappy path for users/delete-user

	Background: To set base
		#Define user info
		* def userName = "carlo"
		* def userEmail = "carlojamespolancos1210@gmail.com"
		* def userPassword = "passSampleword"
		* def getToken = callonce read('classpath:com/api/automation/resources/get-token.feature')
		* def authToken = getToken.authToken
		* def userId = getToken.userId
		Given url _url

	Scenario: Delete account with no authorization
		And path 'users/delete-account'
		And headers { Accept: "application/json" }
		When method delete
		Then status 401
		And match response.message == "No authentication token specified in x-auth-token header"

	Scenario Outline: Delete account with invalid authorization
		And path 'users/delete-account'
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

	Scenario: Delete an account twice
		And path 'users/delete-account'
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method delete
		Then status 200
		And match response.message == "Account successfully deleted"

		And path 'users/delete-account'
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method delete
		Then status 401
		And match response.message == "Access token is not valid or has expired, you will need to login"