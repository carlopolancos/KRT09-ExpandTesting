@regression @users @happy-path @create-user @login-user @logout-user
Feature: Users - Create, Login, Logout, Login, then Delete Happy Path

	Scenario: To test happy path for users/register, /login, /logout, and /delete-account
		#Create random account
		* def randomAccount = callonce read('classpath:com/api/automation/resources/create-random-account.feature')
		* def userName = randomAccount.randomUserName
		* def userEmail = randomAccount.randomUserEmail
		* def userPassword = randomAccount.randomUserPassword
		* def userId = randomAccount.randomUserId
		Given url _url

		#Login user
		And path 'users/login'
		And form field email = userEmail
		And form field password = userPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 200
		And match response.message == "Login successful"
		And match response.data.id == userId
		And match response.data.name == userName
		And match response.data.email == userEmail
		* def authToken = response.data.token

		#Logout
		And path 'users/logout'
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method delete
		Then status 200
		And match response.message == "User has been successfully logged out"

		#Login user
		And path 'users/login'
		And form field email = userEmail
		And form field password = userPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 200
		And match response.message == "Login successful"
		And match response.data.id == userId
		And match response.data.name == userName
		And match response.data.email == userEmail
		* def newAuthToken = response.data.token

		#Delete User
		* def deleteAccount = call read('classpath:com/api/automation/resources/delete-account.feature') { _authToken: "#(newAuthToken)" }