@regression @users @post
Feature: Delete random user

    Scenario: Delete random user from passed parameter
        Given url _url
        And path 'users/login'
        And form field email = _randomUserEmail
        And form field password = _randomUserPassword
        And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
        When method post
        Then status 200
        And match response.message == "Login successful"
        And match response.data.email == _randomUserEmail
        * def randomAuthToken = response.data.token