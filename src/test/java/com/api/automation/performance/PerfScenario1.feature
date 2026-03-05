Feature: sample karate test script

    Background:
        * url 'https://jsonplaceholder.typicode.com'
    # Then print password

    # Scenario: get data from json
    #   Then print __gatling.emailAddress
    #   Then print __gatling.confirmPassword


    # Scenario: create a user and then get it by id
    # * def user =
    #   """
    #   {
    #     "name": "Test User",
    #     "username": __gatling.username,
    #     "email": __gatling.emailID,
    #     "address": {
    #       "street": "Has No Name",
    #       "suite": "Apt. 123",
    #       "city": "Electri",
    #       "zipcode": "54321-6789"
    #     }
    #   }
    #   """

    # Given url 'https://jsonplaceholder.typicode.com/users'
    # Then print __gatling.emailID
    # Then print __gatling.username
    # Then def userData = read('/testData.json')
    # Then set userData.username = __gatling.username
    # Then set userData.email = __gatling.emailID
    # Then print userData
    # And request userData
    # When method post
    # Then status 201

    @smoke
    Scenario: get 1st post by id
        Given path 'posts/1'
        And header karate-name = 'cats-get-404'
        # Then karate.pause(10000)
        When method get
    # * print 'gatling userId:', __gatling.userId
    # * print __gatling.token
    # * print __gatling.role
    # Then print __gatling.emailID
    # Then print __gatling.username

    # Then print baseUrl

    # @regression
    # Scenario: get 1st post by id 3
    # Given path 'posts/1'
    # And header karate-name = 'cats-get-404'
    # Then karate.pause(10000)
    # When method get
    # # Then print baseUrl

    # @regression
    # Scenario: get 1st post by id 2
    # Given path 'posts/10'
    # And header karate-name = 'cats-get-404'
    # # Then karate.pause(10000)
    # When method get
    # # Then print baseUrl