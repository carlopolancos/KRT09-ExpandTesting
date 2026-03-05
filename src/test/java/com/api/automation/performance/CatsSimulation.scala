package com.api.automation.performance

import com.intuit.karate.gatling.KarateProtocol
import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder

import scala.concurrent.duration._

class CatsSimulation extends Simulation {

    val protocol: KarateProtocol = karateProtocol()
    // protocol.runner.configDir("src/test/java/resources")
    // protocol.runner.karateEnv("dev")
    // protocol.runner.systemProperty("myProperty","surendra123")

    // val dataFeed = csv("/Users/lucky/eclipse-workspace/Karate5/src/test/resources/data/testData.csv").random()
    // val dataFeed = jsonFile("/Users/lucky/eclipse-workspace/Karate5/src/test/java/performance/sample.json").random()




    // protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")

    // val create = scenario("create").feed(dataFeed).exec(karateFeature("classpath:performance/PerfScenario1.feature"))
    val create: ScenarioBuilder = scenario("create").exec(karateFeature("classpath:performance/PerfScenario1.feature"))
    //  val create = scenario("create").exec(karateFeature("classpath:performance/PerfScenario1.feature", "@regression"))
    //  val create = scenario("create").exec(karateFeature("classpath:performance/PerfScenario1.feature", "~@ignore"))
    //  val create = scenario("create").exec(karateFeature("classpath:performance/PerfScenario1.feature", "@foo, @bar")) //OR
    //  val create = scenario("create").exec(karateFeature("classpath:performance/PerfScenario1.feature", "@foo","@bar")) //AND
    // val delete = scenario("delete").exec(karateFeature("classpath:performance/PerfScenario2.feature"))

    setUp(
        create.inject( // 1
            nothingFor(5), // 1
            atOnceUsers(5), // 2
            rampUsers(10).during(5), // 3
            constantUsersPerSec(5).during(5), // 4
            rampUsersPerSec(5).to(10).during(5.seconds),
        ).protocols(protocol)// delete.inject(rampUsers(1) during (5 seconds)).protocols(protocol)
    )

}