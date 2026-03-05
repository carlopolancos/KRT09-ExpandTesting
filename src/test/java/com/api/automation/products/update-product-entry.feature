@regression @products @put
Feature: To test the updation of product entry in the test application

	Background: Create and initialize base URL
		Given url 'https://fakestoreapi.com'
		* def newProductBody = read('classpath:com/api/automation/resources/product-entry.json')
		* def getRandomId = function() { return Math.floor(Math.random() * 20) + 1; }
		* def randomProductId = getRandomId()
		* set newProductBody.id = randomProductId

	Scenario: To update the product entry
		#Create a new product entry
		Given path 'products'

		And request newProductBody
		When method post
		Then status 201
		
		#Update entry
		Given path 'products', randomProductId
		* set newProductBody.title = 'Bagong titulo'
		* set newProductBody.description = 'Bagong deskripsyon'
		And request newProductBody
		When method put
		Then status 200
		And match response.title == newProductBody.title
		And match response.description == newProductBody.description

	Scenario: To update the product entry by calling another feature file
		#Create a new product entry
		* call read('classpath:com/api/automation/resources/create-product-entry.feature')
		
		#Update entry
		Given path 'products', randomProductId
		* set newProductBody.title = 'Bagong titulo'
		* set newProductBody.description = 'Bagong deskripsyon'
		And request newProductBody
		When method put
		Then status 200
		And match response.id == randomProductId
#		And match response.id == newProductBody.id
		And match response.title == newProductBody.title
		And match response.description == newProductBody.description