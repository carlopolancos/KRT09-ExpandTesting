package com.api.automation.performance

import com.intuit.karate.gatling.KarateProtocol
import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder

import scala.concurrent.duration._
import scala.language.postfixOps

class PerfRunner extends Simulation {

    val protocol: KarateProtocol = karateProtocol()

    protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")
    protocol.runner.karateEnv("perf")

    val create: ScenarioBuilder = scenario("My 1st perf scenario").exec(karateFeature("classpath:com/api/automation/" +
//        "performance/PerfScenario2.feature"))
        "performance/PerfScenario3.feature"))

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