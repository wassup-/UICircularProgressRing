//
//  UICircularTimerRingTests.swift
//  UICircularProgressRingTests
//
//  Created by Luis on 2/8/19.
//  Copyright © 2019 Luis Padron. All rights reserved.
//

import XCTest
@testable import UICircularProgressRing

class UICircularTimerRingTests: XCTestCase {

    var timerRing: UICircularTimerRing!

    override func setUp() {
        timerRing = UICircularTimerRing()
    }

    func testStartTimer() {
        let normalExpectation = self.expectation(description: "Completion on start")

        timerRing.startTimer(to: 0.1) { state in
            switch state {
            case .finished:
                normalExpectation.fulfill()
            default:
                XCTFail()
            }
        }

        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testPauseTimer() {
        let pauseExpectation = self.expectation(description: "pauses and gives elapsed time")

        timerRing.startTimer(to: 0.2) { state in
            switch state {
            case .finished, .continued:
                XCTFail()
            case .paused:
                pauseExpectation.fulfill()
            }
        }

        // wait 0.1 seconds
        usleep(100000)
        timerRing.pauseTimer()

        //Wait for the expactation to fulfill
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testContinueTimer() {
        let continueExpectation = self.expectation(description: "should pause then continue and finish")


        var expectedFinish = false

        timerRing.startTimer(to: 0.3) { state in
            switch state {
            case .finished:
                if expectedFinish { continueExpectation.fulfill() }
            default: break
            }
        }

        // wait 0.1 seconds
        usleep(100000)
        timerRing.pauseTimer()

        // wait 0.1 seconds
        usleep(100000)
        expectedFinish = true
        timerRing.continueTimer()

        //Wait for the expactation to fulfill
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testTimerStartNotZero() {
        let startExpectation = self.expectation(description: "should start at 10 and animate for 1 second to 11")

        var expectedFinish = false

        timerRing.startTimer(from: 10, to: 11) { state in
            switch state {
            case .finished:
                if expectedFinish { startExpectation.fulfill() }
            default:
                break
            }
        }

        // wait 1 second
        usleep(1000000)
        expectedFinish = true

        waitForExpectations(timeout: 2, handler: nil)
    }
}
