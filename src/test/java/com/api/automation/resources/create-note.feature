Feature: Create random note

    Scenario: Create random note
        #Define note details
        * def noteTitle = "Bagong Titulo ng Noto"
        * def noteDescription = "Bagong Deskripsyon ng Noto"
        * def noteCategory = "Work"

        Given url _url
        Given path 'notes'
        And form field title = noteTitle
        And form field description = noteDescription
        And form field category = noteCategory
        And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
        When method post
        Then status 200
        And match response.message == "Note successfully created"
        And match response.data.title == noteTitle
        And match response.data.description == noteDescription
        And match response.data.category == noteCategory
        And match response.data.user_id == userId
        * def noteId = response.data.id