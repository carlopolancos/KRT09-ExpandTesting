package com.api.automation.carts;

import com.intuit.karate.junit5.Karate;
import com.intuit.karate.junit5.Karate.Test;

public class TestCartsRunner {
	
	@Test
	public Karate runTest() {
		return Karate.run().relativeTo(getClass());
	}
	
}
