@regression @carts @put
Feature: To test the updation of product entry in the test application

	Background: Create and initialize base URL
		Given url 'https://fakestoreapi.com'
		* def newCartBody = read('classpath:com/api/automation/resources/cart-entry.json')
		* def getRandomId = function() { return Math.floor(Math.random() * 7) + 1; }
		* def randomCartId = getRandomId()
		* set newCartBody.id = randomCartId

	Scenario: To update the cart entry
		#Create a new cart entry
		Given path 'carts'

		And request newCartBody
		When method post
		Then status 201
		
		#Update entry
		Given path 'carts', randomCartId
		* set newCartBody.products[0].title = 'Bagong titulo'
		* set newCartBody.products[0].description = 'Bagong deskripsyon'
		And request newCartBody
		When method put
		Then status 200
		And match response.products.[*].title contains newCartBody.products[0].title
		And match response.products.[*].description contains newCartBody.products[0].description

	Scenario: To update the cart entry by calling another feature file
		#Create a new cart entry
		* call read('classpath:com/api/automation/resources/create-cart-entry.feature')
		
		#Update entry
		Given path 'carts', randomCartId
		* set newCartBody.jobTitle = 'Bagong titulo'
		* set newCartBody.jobDescription = 'Bagong deskripsyon'
		And request newCartBody
		When method put
		Then status 200
		And match response.id == randomCartId
#		And match response.id == newCartBody.id
		And match response.products.[*].title contains newCartBody.products[0].title
		And match response.products.[*].description contains newCartBody.products[0].description