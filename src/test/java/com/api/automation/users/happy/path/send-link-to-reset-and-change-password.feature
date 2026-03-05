@regression @users @happy-path @send-password-reset-link @change-password
Feature: Users - Send Password Reset Link and Change Password Happy Path

	Scenario: To test happy path for users/forgot-password and /change-password
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

		#Send password reset link
		And path 'users/forgot-password'
		And form field email = userEmail
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded"}
		When method post
		Then status 200
		And match response.message == "Password reset link successfully sent to "+userEmail+". Please verify by clicking on the given link"

		#Change Password
		* def newUserPassword = "samPasswordple"
		And path 'users/change-password'
		And form field currentPassword = userPassword
		And form field newPassword = newUserPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method post
		Then status 200
		And match response.message == "The password was successfully updated"

		#Delete User
		* def deleteAccount = call read('classpath:com/api/automation/resources/delete-account.feature') { _authToken: "#(authToken)" }