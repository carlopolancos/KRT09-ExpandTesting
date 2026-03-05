Feature: Test GET endpoint of the Products path of the application

    Background:
        * url 'https://fakestoreapi.com'

    Scenario: Get all products
        Given path 'products'
        When method get
        Then status 200