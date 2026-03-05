@debug @signup
Feature: Sign Up random user

    Scenario: New user sign up
        * def getRandomEmail =
            """
            function() {
                var Generator = Java.type('com.api.automation.resources.DataGenerator');
                var instance = new Generator();
                return instance.getRandomEmail();
            }
            """
        * def getRandomUsername =
            """
            function() {
                var Generator = Java.type('com.api.automation.resources.DataGenerator');
                var instance = new Generator();
                return instance.getRandomUsername();
            }
            """
        * def getRandomPassword =
            """
            function() {
                var Generator = Java.type('com.api.automation.resources.DataGenerator');
                var instance = new Generator();
                return instance.getRandomPassword();
            }
            """

        * def randomUserName = getRandomUsername()
        * def randomUserEmail = getRandomEmail()
        * def randomUserPassword = getRandomPassword()

        Given url _url
        And path 'users/register'
        And form field name = randomUserName
        And form field email = randomUserEmail
        And form field password = randomUserPassword
        And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded" }
        When method post
        Then status 201
        And match response.message == "User account created successfully"
        And match response.data.name == randomUserName
        And match response.data.email == randomUserEmail
        * def randomUserId = response.data.id