@regression @users @unhappy-path @login-user @post
Feature: To test unhappy path for users/login

	Background: To set base
		#Define user info
		* def userName = "carlo"
		* def userEmail = "carlojamespolancos1210@gmail.com"
		* def userPassword = "passSampleword"
		* def getToken = callonce read('classpath:com/api/automation/resources/get-token.feature')
		Given url _url

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
		* def deleteAccount = call read('classpath:com/api/automation/resources/delete-account.feature') { _authToken: "#(randomAuthToken)" }

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
		* def deleteAccount = call read('classpath:com/api/automation/resources/delete-account.feature') { _authToken: "#(randomAuthToken)" }