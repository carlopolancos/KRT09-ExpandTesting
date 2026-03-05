@regression @notes @happy-path
Feature: Notes - Get, Creates, Gets, Updates then Delete Happy Path

	Scenario: To test happy path for notes/
		#Define note info
		* def noteTitle = "KRT09-ExpandTesting"
		* def noteDescription = "Expand testing expand testing expand testing expand testing."
		* def noteCategory = "Home"
		#Category can only be: Home, Work or Personal
		* def getToken = callonce read('classpath:com/api/automation/resources/get-token.feature')
		* def authToken = getToken.authToken
		* def userId = getToken.userId
		Given url _url

		* def noteSchema =
			"""
			{
				"id": "#string",
				"title": "#string",
				"description": "#string",
				"category": "#string",
				"completed": "#boolean",
				"created_at": "#regex ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z$",
				"updated_at": "#regex ^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z$",
				"user_id": "#(userId)"
			}
			"""

		#Get notes
		* path 'notes'
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method get
		Then status 200
		And match response.message == "No notes found"

		#Create note
		* path 'notes'
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

		#Create note
		* path 'notes'
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

		#Create note
		* path 'notes'
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

		#Get notes
		* path 'notes'
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method get
		Then status 200
		And match response.message == "Notes successfully retrieved"
		And match response.data == "#[] ##(noteSchema)"
		* def firstNote = response.data[0]
		* def firstNodeId = firstNote.id

		#Get a note
		* path 'notes', firstNodeId
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method get
		Then status 200
		And match response.message == "Note successfully retrieved"
		And match response.data == firstNote

		#Update note details
		* def newNoteTitle = "Bagong Titulo ng Noto"
		* def newNoteDescription = "Bagong Deskripsyon ng Noto"
		* def newNoteCategory = "Personal"

		* path 'notes', firstNodeId
		And form field title = newNoteTitle
		And form field description = newNoteDescription
		And form field category = newNoteCategory
		And form field completed = true
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method put
		Then status 200
		And match response.message == "Note successfully Updated"
		And match response.data.title == newNoteTitle
		And match response.data.description == newNoteDescription
		And match response.data.category == newNoteCategory
		And match response.data.user_id == userId
		And match response.data.completed == true

		#Update note completion
		* path 'notes', firstNodeId
		And form field completed = false
		And headers { Accept: "application/json", Content-Type: "application/x-www-form-urlencoded", x-auth-token: "#(authToken)" }
		When method patch
		Then status 200
		And match response.message == "Note successfully Updated"
		And match response.data.title == newNoteTitle
		And match response.data.description == newNoteDescription
		And match response.data.category == newNoteCategory
		And match response.data.user_id == userId
		And match response.data.completed == false

		#Delete note
		*  path 'notes', firstNodeId
		And headers { Accept: "application/json", x-auth-token: "#(authToken)" }
		When method delete
		Then status 200
		And match response.message == "Note successfully deleted"

		#Delete User
		* def deleteAccount = call read('classpath:com/api/automation/resources/delete-account.feature') { _authToken: "#(getToken.authToken)" }