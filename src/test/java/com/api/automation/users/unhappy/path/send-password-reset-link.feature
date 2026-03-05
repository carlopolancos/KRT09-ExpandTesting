@regression @users @unhappy-path @send-password-reset-link @post
Feature: To test unhappy path for users/forgot-password

	Background: To set base
		#Define user info
		* def userName = "carlo"
		* def userEmail = "carlojamespolancos1210@gmail.com"
		* def userPassword = "passSampleword"
		* def getToken = callonce read('classpath:com/api/automation/resources/get-token.feature')
		Given url _url

	Scenario: Send password reset link to blank email address
		And path 'users/forgot-password'
		And form field email = ""
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded"}
		When method post
		Then status 400
		And match response.message == "A valid email address is required"

	Scenario: Send password reset link to an invalid email address
		And path 'users/forgot-password'
		And form field email = "carlo.polancos@awsys-i.co"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded"}
		When method post
		Then status 401
		And match response.message == "No account found with the given email address"