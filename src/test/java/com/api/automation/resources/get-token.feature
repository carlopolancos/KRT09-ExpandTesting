Feature: Authorization Helper

    Scenario: Login set user credentials
        * def randomAccount = callonce read('classpath:com/api/automation/resources/create-random-account.feature')
        * def randomUserEmail = randomAccount.randomUserEmail
        * def randomUserPassword = randomAccount.randomUserPassword

        Given url _url
        And path 'users/login'
        And form field email = randomUserEmail
        And form field password = randomUserPassword
        And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
        When method post
        Then status 200
        And match response.message == "Login successful"
        And match response.data.email == randomUserEmail
        * def userId = response.data.id
        * def authToken = response.data.token