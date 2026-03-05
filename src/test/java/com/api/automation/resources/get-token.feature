@debug @signup
Feature: Sign Up random user

    Scenario: New user sign up
        * def userEmail = "carlo.polancos@awsys-i.com"
        * def userPassword = "passSampleword"

        Given url _url
        And path 'users/login'
        And form field email = userEmail
        And form field password = userPassword
        And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
        When method post
        Then status 200
        And match response.message == "Login successful"
        And match response.data.email == userEmail
        * def authToken = response.data.token