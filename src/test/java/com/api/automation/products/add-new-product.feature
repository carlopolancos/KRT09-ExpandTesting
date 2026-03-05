@regression @products @post
Feature: To create the Product entry in the application

	Scenario: To create the product entry
		* def newJsonRequestBody = read('classpath:com/api/automation/resources/product-entry.json')
		Given url 'https://fakestoreapi.com'
		And path 'products'
		And request newJsonRequestBody
		When method post
		Then status 201
		And match response.title == newJsonRequestBody.title
		And match response.id == 21