@regression @carts @delete
Feature: To test DELETE end point of appliation

	Scenario: To delete cart
		* def getRandomId = function() { return Math.floor(Math.random() * 7) + 1; }
		* def randomCartId = getRandomId();

		Given url 'https://fakestoreapi.com'
		And path 'carts', randomCartId
		When method delete
		Then status 200
		And match response.id == randomCartId
