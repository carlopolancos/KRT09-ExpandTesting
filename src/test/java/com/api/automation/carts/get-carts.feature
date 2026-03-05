@regression @carts @get
Feature: To test the GET end point of the application

    Background: Setup the Base path
        Given url 'https://fakestoreapi.com'
        * def productSchema = { "productId": "#number", "quantity": "#number" }
        * def expectedJsonResponse = read('classpath:com/api/automation/resources/carts-response.json')

    Scenario: To get all the data
        Given path 'carts'
        When method get
        Then status 200
        And match each response == expectedJsonResponse

    Scenario: To get a single cart
        * def getRandomId = function() { return Math.floor(Math.random() * 7) + 1; }
        * def randomCartId = getRandomId();
        Given path 'carts/', randomCartId
        When method get
        Then status 200
        And match response == expectedJsonResponse
        And match response.id == randomCartId