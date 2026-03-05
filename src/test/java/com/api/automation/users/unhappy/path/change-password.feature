@regression @users @unhappy-path @post @change-password
Feature: To test unhappy path for users/change-password

	Background: To set base
		#Define user info
		* def userName = "carlo"
		* def userEmail = "carlojamespolancos1210@gmail.com"
		* def userPassword = "passSampleword"
		* def getToken = callonce read('classpath:com/api/automation/resources/get-token.feature')
		Given url _url

	Scenario: Change password with invalid current password
		And path 'users/change-password'
		And form field currentPassword = "passSamplewordd"
		And form field newPassword = "qwwqeqwewqewqeewq"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(getToken.authToken)" }
		When method post
		Then status 400
		And match response.message == "The current password is incorrect"

	Scenario: Change password with no authorization
		And path 'users/change-password'
		And form field currentPassword = "passSamplewordd"
		And form field newPassword = "qwwqeqwewqewqeewq"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded"}
		When method post
		Then status 401
		And match response.message == "No authentication token specified in x-auth-token header"

	Scenario Outline: Change password with invalid authorization
		And path 'users/change-password'
		And form field currentPassword = "passSamplewordd"
		And form field newPassword = "qwwqeqwewqewqeewq"
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