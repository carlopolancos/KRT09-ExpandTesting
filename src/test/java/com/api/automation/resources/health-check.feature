Feature: Use this API endpoint to check if the server is running and healthy

    Scenario: Check server status
        Given url _url
        And path 'health-check'
        When method get
        Then status 200
        And match response ==
        """
        {
            "success": true,
            "status": 200,
            "message": "Notes API is Running"
        }
        """