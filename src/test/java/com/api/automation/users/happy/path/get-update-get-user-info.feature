@regression @users @happy-path @get-user-info @update-user
Feature: Users - Get Info, Update Info, then Get Advanced Info Happy Path

	Scenario: To test happy path for users/profile
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

		#Delete User
		* def deleteAccount = call read('classpath:com/api/automation/resources/delete-account.feature') { _authToken: "#(authToken)" }