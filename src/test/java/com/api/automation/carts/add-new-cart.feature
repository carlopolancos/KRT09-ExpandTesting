@regression @carts @post
Feature: To create the Product entry in the application

	Scenario: To create the product entry
		* def newJsonRequestBody = read('classpath:com/api/automation/resources/cart-entry.json')
		Given url 'https://fakestoreapi.com'
		And path 'carts'
		And request newJsonRequestBody
		When method post
		Then status 201
		And match response.id == 11
		And match response.products.[*].title contains newJsonRequestBody.products[0].title