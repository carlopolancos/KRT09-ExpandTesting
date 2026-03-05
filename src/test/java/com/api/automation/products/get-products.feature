@regression @products @get
Feature: To test the GET end point of the application

    Background: Setup the Base path
        Given url 'https://fakestoreapi.com'
        * def expectedJsonResponse = read('classpath:com/api/automation/resources/product-response.json')

    Scenario: To get all the data
        Given path 'products'
        When method get
        Then status 200
        And match each response == expectedJsonResponse

    Scenario: To get a single product
        * def getRandomId = function() { return Math.floor(Math.random() * 20) + 1; }
        * def randomProductId = getRandomId();
        Given path 'products/', randomProductId
        When method get
        Then status 200
        And match response == expectedJsonResponse
        And match response.id == randomProductId