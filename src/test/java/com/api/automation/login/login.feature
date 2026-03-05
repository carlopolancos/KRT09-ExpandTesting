@regression @login
Feature: To test login feature of application

	Background: To setup base
		* def loginPayload = read('classpath:com/api/automation/resources/login-credentials.json')
		Given url 'https://fakestoreapi.com'
		And path 'auth/login'

	Scenario: To login with valid user credentials
		And request loginPayload
		When method post
		Then status 201
		* def authToken = response.token
		* print authToken

	Scenario: To login with invalid user credentials
		* set loginPayload.username = "johndd"
		And request loginPayload
		When method post
		Then status 401
		And match response == "username or password is incorrect"