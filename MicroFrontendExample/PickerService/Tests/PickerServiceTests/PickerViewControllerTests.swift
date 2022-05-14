//
//  PickerViewControllerTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

@testable import PickerService

import BaseSwiftMocks
import CommonTypes
import SwiftCurrent
import SwiftCurrent_Testing
import UIUTest
import XCTest

final class PickerViewControllerTests: XCTestCase {
    let userDefaults = UserDefaults.test

    override func tearDown() {
        userDefaults.removeAllValues()
    }

    func testFlowRepresentableName() {
        XCTAssertEqual(PickerViewController.flowRepresentableName, WorkflowElement.picker.rawValue)
    }

    func testButtonColorsAreInstalledCorrectly() throws {
        let viewController = UIViewController.loadFromStoryboard(identifier: PickerViewController.storyboardId, storyboard: PickerViewController.storyboardName, bundle: Bundle.module)
        let redButton = viewController?.view?.viewWithAccessibilityIdentifier("red")
        let greenButton = viewController?.view?.viewWithAccessibilityIdentifier("green")
        let blueButton = viewController?.view?.viewWithAccessibilityIdentifier("blue")

        XCTAssertEqual(redButton?.backgroundColor, Color.red.value)
        XCTAssertEqual(greenButton?.backgroundColor, Color.green.value)
        XCTAssertEqual(blueButton?.backgroundColor, Color.blue.value)
    }

    func testAttemptsCountIsLabeled() throws {
        let expectedValue = 1234
        userDefaults.set(expectedValue, forKey: PickerService.attemptCountKey)
        _ = PickerService(userDefaults: userDefaults)

        let viewController = UIViewController.loadFromStoryboard(identifier: PickerViewController.storyboardId, storyboard: PickerViewController.storyboardName, bundle: Bundle.module)
        viewController?.viewWillAppear(false)
        let attemptsLabel = viewController?.view?.viewWithAccessibilityIdentifier("attempts") as? UILabel

        XCTAssertEqual(attemptsLabel?.text, "\(expectedValue)")
    }

    func testPickingColorProceedsInWorkflowWithColorArgument() {
        _ = PickerService(userDefaults: userDefaults)

        var selectedColor: Color?
        let flowRepresentable = AnyFlowRepresentable(PickerViewController.self, args: .none)
        var viewController = flowRepresentable.underlyingInstance as! PickerViewController
        viewController._proceedInWorkflow = { selectedColor = $0 as? Color }
        viewController.loadForTesting()

        Color.allCases.forEach { color in
            let button = viewController.view?.viewWithAccessibilityIdentifier("\(color)") as! UIButton
            viewController.pickColor(sender: button)
            XCTAssertEqual(selectedColor, color)
        }
    }

    func testAttemptResetNotificationResetsAttemptsLabel() {
        let notificationCenter = NotificationCenter()
        userDefaults.set(1, forKey: PickerService.attemptCountKey)
        _ = PickerService(notificationCenter: notificationCenter, userDefaults: userDefaults)

        let viewController = UIViewController.loadFromStoryboard(identifier: PickerViewController.storyboardId, storyboard: PickerViewController.storyboardName, bundle: Bundle.module)
        viewController?.viewWillAppear(false)
        let attemptsLabel = viewController?.view?.viewWithAccessibilityIdentifier("attempts") as? UILabel

        notificationCenter.post(name: .resetAttemptsAndStatistics, object: nil)
        flushDispatchQueue(.main)

        XCTAssertEqual(attemptsLabel?.text, "0")
    }

    func testResetButtonPostsAttemptResetNotification() {
        var notificationReceiveCount = 0
        let notificationCenter = NotificationCenter()
        notificationCenter.addObserver(forName: .resetAttemptsAndStatistics, object: nil, queue: nil) { _ in notificationReceiveCount += 1 }
        _ = PickerService(notificationCenter: notificationCenter, userDefaults: userDefaults)
        let viewController = UIViewController.loadFromStoryboard(identifier: PickerViewController.storyboardId, storyboard: PickerViewController.storyboardName, bundle: Bundle.module) as? PickerViewController

        viewController?.resetAttemptsAndStatistics()

        XCTAssertEqual(notificationReceiveCount, 1)
    }
}
