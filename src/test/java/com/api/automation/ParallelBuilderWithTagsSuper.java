package com.api.automation;

import com.api.automation.config.report.CustomExtentReport;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class ParallelBuilderWithTagsSuper {

	//open this file's run configuration to edit tags

	/* Available tags:
	 * @regression (all)
	 *
	 * PER PATH
	 * @products
	 * @carts
	 * @users
	 *
	 * PER METHOD
	 * @post
	 * @delete
	 * @get
	 * @put
	 *
	 * */
	
	private static final String CLASS_PATH = "classpath:";
	
	@Test // Standard JUnit 5 annotation
    void testParallel() {
        Results results = Runner.path(getLocation().toArray(new String[0]))
                .tags(getTags().toArray(new String[0]))
//				.reportDir("target/karate-reports/tags-run")
                .outputCucumberJson(true)
                .parallel(5);
		generateCucumberReport(results.getReportDir());

		//Extent Report
		CustomExtentReport extentReport = new CustomExtentReport()
				.withKarateResult(results)
				.withReportDir(results.getReportDir())
				.withReportTitle("Karate Test Execution Report");
		extentReport.generateExtentReport();
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
	
	private List<String> getTags() {
		String aTags = System.getProperty("tags", "@regression");
		List<String> aTagList = Arrays.asList(aTags);
		return aTagList;
	}

	private List<String> getLocation() {
		String aLocation = System.getProperty("location", "com/api/automation");
		List<String> aLocationList = Arrays.asList(CLASS_PATH+aLocation);
		return aLocationList;
	}

	void generateCucumberReport(String reportDirLocation) {
		File reportDir = new File(reportDirLocation);
		Collection<File> jsonCollection = FileUtils.listFiles(reportDir, new String[] {"json"}, true);

		List<String> jsonFiles = new ArrayList<String>();
		jsonCollection.forEach(file -> jsonFiles.add(file.getAbsolutePath()));

		Configuration configuration = new Configuration(reportDir, "Karate Run");
		ReportBuilder reportBuilder = new ReportBuilder(jsonFiles, configuration);
		reportBuilder.generateReports();
	}
}
