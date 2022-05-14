//
//  RevealViewControllerTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

@testable import RevealService

import BaseSwiftMocks
import CommonTypes
import SwiftCurrent
import UIUTest
import XCTest

final class RevealViewControllerTests: XCTestCase {

    func testFlowRepresentableName() {
        XCTAssertEqual(RevealViewController.flowRepresentableName, WorkflowElement.reveal.rawValue)
    }

    func testColorChoiceIsLabeledAndStatisticsLabelsAreCorrect() throws {
        var expectedValues = [Int64(0), 0, 0]
        let service = makeTestRevealService()

        Color.allCases.forEach { color in
            let viewController = loadViewController(with: color)
            expectedValues[color.rawValue] += 1

            let choiceLabel = viewController.view?.viewWithAccessibilityIdentifier("choice") as? UILabel
            let statisticsLabel = viewController.view?.viewWithAccessibilityIdentifier("\(color)Count") as? UILabel
            XCTAssertEqual(choiceLabel?.text, "Your color is \(color.name)!")
            XCTAssertEqual(statisticsLabel?.text, "\(expectedValues[color.rawValue])")

            let statistics = service.fetchStatistics()
            XCTAssertEqual(statistics.red, expectedValues[Color.red.rawValue])
            XCTAssertEqual(statistics.green, expectedValues[Color.green.rawValue])
            XCTAssertEqual(statistics.blue, expectedValues[Color.blue.rawValue])
        }
    }

    func testSampleColors() {
        _ = makeTestRevealService()
        UIView.setAnimationsEnabled(false)

        Color.allCases.forEach { color in
            let viewController = loadViewController(with: color)
            viewController.viewDidAppear(false)
            let sampleView1 = viewController.view?.viewWithAccessibilityIdentifier("sample1")
            let sampleView2 = viewController.view?.viewWithAccessibilityIdentifier("sample2")

            XCTAssertEqual(sampleView1?.alpha, 0.5)
            XCTAssertEqual(sampleView1?.backgroundColor, color.value)
            XCTAssertEqual(sampleView2?.alpha, 0.5)
            XCTAssertEqual(sampleView2?.backgroundColor, color.value)
        }

        UIView.setAnimationsEnabled(true)
    }

    func testStatisticsResetNotificationResetsStatisticsLabels() {
        let notificationCenter = NotificationCenter()
        _ = makeTestRevealService(notificationCenter: notificationCenter)

        let viewController = loadViewController(with: .red)
        let redCountLabel = viewController.view?.viewWithAccessibilityIdentifier("redCount") as? UILabel
        let greenCountLabel = viewController.view?.viewWithAccessibilityIdentifier("greenCount") as? UILabel
        let blueCountLabel = viewController.view?.viewWithAccessibilityIdentifier("blueCount") as? UILabel

        XCTAssertEqual(redCountLabel?.text, "1")
        XCTAssertEqual(greenCountLabel?.text, "0")
        XCTAssertEqual(blueCountLabel?.text, "0")

        notificationCenter.post(name: .resetAttemptsAndStatistics, object: nil)
        flushDispatchQueue(.main)

        XCTAssertEqual(redCountLabel?.text, "0")    // red is now zero
        XCTAssertEqual(greenCountLabel?.text, "0")
        XCTAssertEqual(blueCountLabel?.text, "0")
    }
}

extension RevealViewControllerTests {

    private func loadViewController(with pick: Color) -> RevealViewController {
        let flowRepresentable = AnyFlowRepresentable(RevealViewController.self, args: AnyWorkflow.PassedArgs.args(pick))
        let result = flowRepresentable.underlyingInstance as! RevealViewController
        result.loadForTesting()
        return result
    }
}
