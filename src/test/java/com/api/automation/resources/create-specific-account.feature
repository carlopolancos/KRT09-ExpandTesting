@debug @signup
Feature: Sign Up new user

    Scenario: New user sign up
        Given url _url
        And path 'users/register'
        And form field name = _userName
        And form field email = _userEmail
        And form field password = _userPassword
        And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
        When method post
        Then status 201
        And match response.message == "User account created successfully"
        And match response.data.name == _userName
        And match response.data.email == _userEmail
        * def userId = response.data.id