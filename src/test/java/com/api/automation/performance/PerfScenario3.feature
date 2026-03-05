Feature: Test Products path of the application

    Background:
        * url 'https://fakestoreapi.com'
        * def expectedJsonResponse = read('classpath:com/api/automation/resources/product-response.json')

    Scenario: Get all products
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

    Scenario: To create the product entry
        * def newJsonRequestBody = read('classpath:com/api/automation/resources/product-entry.json')
        Given url 'https://fakestoreapi.com'
        And path 'products'
        And request newJsonRequestBody
        When method post
        Then status 201
        And match response.title == newJsonRequestBody.title
        And match response.id == 21

    Scenario: To delete product
        * def getRandomId = function() { return Math.floor(Math.random() * 20) + 1; }
        * def randomProductId = getRandomId();

        Given url 'https://fakestoreapi.com'
        And path 'products', randomProductId
        When method delete
        Then status 200
        And match response.id == randomProductId

    Scenario: To update the product entry
        * def newProductBody = read('classpath:com/api/automation/resources/product-entry.json')
        * def getRandomId = function() { return Math.floor(Math.random() * 20) + 1; }
        * def randomProductId = getRandomId()
        * set newProductBody.id = randomProductId

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
        * def newProductBody = read('classpath:com/api/automation/resources/product-entry.json')
        * def getRandomId = function() { return Math.floor(Math.random() * 20) + 1; }
        * def randomProductId = getRandomId()
        * set newProductBody.id = randomProductId

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