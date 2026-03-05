package com.api.automation;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;

public class ParallelBuilder {
	
	@Test // Standard JUnit 5 annotation
    void testParallel() {
        Results results = Runner.path("classpath:com/api/automation")
	        		.tags("@confidence, @smoke, @regression") //Comma = OR
//    			.tags("@confidence", "@smoke", "@regression") // Separate args = AND
	        		.reportDir("target/karate-reports/tags-run")
                .outputCucumberJson(true)
                .parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
