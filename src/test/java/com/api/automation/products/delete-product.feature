@regression @products @delete
Feature: To test DELETE end point of appliation

	Scenario: To delete product
		* def getRandomId = function() { return Math.floor(Math.random() * 20) + 1; }
		* def randomProductId = getRandomId();

		Given url 'https://fakestoreapi.com'
		And path 'products', randomProductId
		When method delete
		Then status 200
		And match response.id == randomProductId
