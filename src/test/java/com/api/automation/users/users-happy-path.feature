@regression @users @post
Feature: Test User path

	Scenario: To test happy path for users/
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

		#Get User Info
		And path 'users/profile'
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method get
		Then status 200
		And match response.message == "Profile successful"
		And match response.data.id == userId
		And match response.data.name == userName
		And match response.data.email == userEmail

		#Update User Info
		* def newUserName = "james"
		* def userPhone = "0987654321"
		* def userCompany = "Example Company"
		And path 'users/profile'
		And form field name = newUserName
		And form field phone = userPhone
		And form field company = userCompany
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method patch
		Then status 200
		And match response.message == "Profile updated successful"
		And match response.data.id == userId
		And match response.data.name == newUserName
		And match response.data.email == userEmail
		And match response.data.phone == userPhone
		And match response.data.company == userCompany

		#Get Advanced User Info
		And path 'users/profile'
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method get
		Then status 200
		And match response.message == "Profile successful"
		And match response.data.id == userId
		And match response.data.name == newUserName
		And match response.data.email == userEmail
		And match response.data.phone == userPhone
		And match response.data.company == userCompany

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

		#Logout
		And path 'users/logout'
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method delete
		Then status 200
		And match response.message == "User has been successfully logged out"

		#Login user
		And path 'users/login'
		And form field email = userEmail
		And form field password = newUserPassword
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
		When method post
		Then status 200
		And match response.message == "Login successful"
		And match response.data.id == userId
		And match response.data.name == newUserName
		And match response.data.email == userEmail
		* def newAuthToken = response.data.token

		#Delete User
		* def deleteAccount = call read('classpath:com/api/automation/resources/delete-account.feature') { _randomAuthToken: "#(newAuthToken)" }