@regression @users @happy-path @create-user @login-user @logout-user
Feature: Create, Login, Logout, Login, then Delete Happy Path

	Scenario: To test happy path for users/register, /login, /logout, and /delete-account
		#Define user info
		* def userName = "carlo"
		* def userEmail = "polancoscarlojames1210@gmail.com"
		* def userPassword = "passSampleword"
		Given url _url

		#Create user
		* def createAccount = call read('classpath:com/api/automation/resources/create-specific-account.feature') { _userName: "#(userName)", _userEmail: "#(userEmail)", _userPassword: "#(userPassword)" }
		* def userId = createAccount.userId

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