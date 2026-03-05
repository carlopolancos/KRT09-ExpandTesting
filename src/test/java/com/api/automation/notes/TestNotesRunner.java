package com.api.automation.notes;

import com.intuit.karate.junit5.Karate;
import com.intuit.karate.junit5.Karate.Test;

public class TestNotesRunner {
	
	@Test
	public Karate runTest() {
		return Karate.run().relativeTo(getClass());
	}
	
}
