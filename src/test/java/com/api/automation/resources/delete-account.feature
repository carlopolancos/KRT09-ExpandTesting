Feature: Delete random user from passed parameter

    Scenario: Delete random user from passed parameter
        Given url _url
        And path 'users/delete-account'
        And headers { Accept: "application/json", x-auth-token: "#(_authToken)" }
        And method delete
        Then status 200
        And match response.message == "Account successfully deleted"