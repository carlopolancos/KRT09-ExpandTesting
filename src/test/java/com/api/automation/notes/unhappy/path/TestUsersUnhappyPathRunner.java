package com.api.automation.notes.unhappy.path;

import com.intuit.karate.junit5.Karate;
import com.intuit.karate.junit5.Karate.Test;

public class TestUsersUnhappyPathRunner {
	
	@Test
	public Karate runTest() {
		return Karate.run().relativeTo(getClass());
	}
	
}
