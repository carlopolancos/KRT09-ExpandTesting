@regression @users @post
Feature: To test unhappy path for users/

	Background: To set base
		#Define user info
		* def userName = "carlo"
		* def userEmail = "carlojamespolancos1210@gmail.com"
		* def userPassword = "passSampleword"

		Given url _url

		* def getToken = callonce read('classpath:com/api/automation/resources/get-token.feature')

	Scenario: Create a similar account with same email address
		* def userEmail = "carlo.polancos@awsys-i.com"

		#Create user
		And path 'users/register'
		And form field name = userName
		And form field email = userEmail
		And form field password = userPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 409
		And match response.message == "An account already exists with the same email address"

	Scenario: Create an account with invalid email address
		* def userEmail = "carlojamespolancos1210"

		#Create user
		And path 'users/register'
		And form field name = userName
		And form field email = userEmail
		And form field password = userPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 400
		And match response.message == "A valid email address is required"

	Scenario: Create an account with invalid password
		* def userPassword = ""

		#Create user
		And path 'users/register'
		And form field name = userName
		And form field email = userEmail
		And form field password = userPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 400
		And match response.message == "Password must be between 6 and 30 characters"

	Scenario: Login with non-existing account
		And path 'users/login'
		And form field email = userEmail
		And form field password = userPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 401
		And match response.message == "Incorrect email address or password"

	Scenario: Login with invalid email
		* def createRandomAccount = call read('classpath:com/api/automation/resources/create-random-account.feature')

		#Try invalid login
		And path 'users/login'
		And form field email = "maling@email.com"
		And form field password = createRandomAccount.randomUserPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 401
		And match response.message == "Incorrect email address or password"

		#Proper login
		* def loginAccount = call read('classpath:com/api/automation/resources/proper-account-login.feature') { _randomUserEmail: "#(createRandomAccount.randomUserEmail)", _randomUserPassword: "#(createRandomAccount.randomUserPassword)" }
		* def randomAuthToken = loginAccount.response.data.token

		#Delete User
		* def deleteAccount = call read('classpath:com/api/automation/resources/delete-account.feature') { _randomAuthToken: "#(randomAuthToken)" }

	Scenario: Login with invalid password
		* def createRandomAccount = call read('classpath:com/api/automation/resources/create-random-account.feature')

		#Try invalid login
		And path 'users/login'
		And form field email = createRandomAccount.randomUserEmail
		And form field password = "malipasswordhahaha"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 401
		And match response.message == "Incorrect email address or password"

		#Proper login
		* def loginAccount = call read('classpath:com/api/automation/resources/proper-account-login.feature') { _randomUserEmail: "#(createRandomAccount.randomUserEmail)", _randomUserPassword: "#(createRandomAccount.randomUserPassword)" }
		* def randomAuthToken = loginAccount.response.data.token

		#Delete User
		* def deleteAccount = call read('classpath:com/api/automation/resources/delete-account.feature') { _randomAuthToken: "#(randomAuthToken)" }

	Scenario: Get User Info using invalid auth token
		#Try to get user info
		And path 'users/profile'
		And headers { Accept: "application/json", x-auth-token: "quequequequequqe" }
		When method get
		Then status 401
		And match response.message == "Access token is not valid or has expired, you will need to login"

	Scenario: Update user info with invalid name
		#Try to update user info
		And path 'users/profile'
		And form field name = "cac"
		And form field phone = "0987654321"
		And form field company = "Example Company"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(getToken.authToken)" }
		When method patch
		Then status 400
		And match response.message == "User name must be between 4 and 30 characters"

	Scenario: Update user info with invalid phone
		#Try to update user info
		And path 'users/profile'
		And form field name = "carlo"
		And form field phone = "aaaaaaaaaa"
		And form field company = "Example Company"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(getToken.authToken)" }
		When method patch
		Then status 400
		And match response.message == "Phone number should be between 8 and 20 digits"

	Scenario: Update user info with invalid company
		#Try to update user info
		And path 'users/profile'
		And form field name = "carlo"
		And form field phone = "aaaaaaaaaa"
		And form field company = "Exa"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(getToken.authToken)" }
		When method patch
		Then status 400
		And match response.message == "Company name must be between 4 and 30 characters"

	Scenario: Send passwrod reset link to an invalid email address
		#Try to update user info
		And path 'users/forgot-password'
		And form field email = ""
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded"}
		When method post
		Then status 400
		And match response.message == "A valid email address is required"

	Scenario: Send passwrod reset link to an invalid email address
		#Try to update user info
		And path 'users/forgot-password'
		And form field email = "carlo.polancos@awsys-i.co"
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded"}
		When method post
		Then status 401
		And match response.message == "No account found with the given email address"