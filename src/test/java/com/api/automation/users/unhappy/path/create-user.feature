@regression @users @unhappy-path @create-user @post
Feature: To test unhappy path for users/create-user

	Background: To set base
		#Define user info
		* def userName = "carlo"
		* def userEmail = "carlojamespolancos1210@gmail.com"
		* def userPassword = "passSampleword"
		* def getToken = callonce read('classpath:com/api/automation/resources/get-token.feature')
		Given url _url

	Scenario: Create a similar account with same email address
		* def userEmail = "carlo.polancos@awsys-i.com"

		And path 'users/register'
		And form field name = userName
		And form field email = userEmail
		And form field password = userPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 409
		And match response.message == "An account already exists with the same email address"

	Scenario Outline: Create an account with invalid email address
		* def userEmail = "<email>"

		And path 'users/register'
		And form field name = userName
		And form field email = userEmail
		And form field password = userPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 400
		And match response.message == "A valid email address is required"
		Examples:
		| email                  |
		| ''                     |
		| carlojamespolancos1210 |

	Scenario: Create an account with no email address field
		And path 'users/register'
		And form field email = userEmail
		And form field password = userPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 400
		And match response.message == "User name must be between 4 and 30 characters"

	Scenario Outline: Create an account with invalid name
		And path 'users/register'
		And form field name = "<userName>"
		And form field email = userEmail
		And form field password = userPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 400
		And match response.message == "User name must be between 4 and 30 characters"
		Examples:
		| userName                                               |
		| ''                                                     |
		| cal                                                    |
		| carloJamesPolancoscarloJamesPolancoscarloJamesPolancos |

	Scenario: Create an account with no name field
		And path 'users/register'
		And form field name = userName
		And form field password = userPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 400
		And match response.message == "A valid email address is required"

	Scenario Outline: Create an account with invalid password
		And path 'users/register'
		And form field name = userName
		And form field email = userEmail
		And form field password = "<userPassword>"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 400
		And match response.message == "Password must be between 6 and 30 characters"
		Examples:
		| userPassword                               |
		| ''                                         |
		| passS                                      |
		| passSamplewordpassSamplewordpassSampleword |

	Scenario: Create an account with no password field
		And path 'users/register'
		And form field name = userName
		And form field email = userEmail
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 400
		And match response.message == "Password must be between 6 and 30 characters"