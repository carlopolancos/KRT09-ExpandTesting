package com.api.automation.resources;

import com.intuit.karate.junit5.Karate;
import com.intuit.karate.junit5.Karate.Test;

public class TestResourcesRunner {
	
	@Test
//	public Karate runTest() {
//		return Karate.run().relativeTo(getClass());
//	}
	public Karate runTest() {
		return Karate.run("health-check").relativeTo(getClass());
	}

}
