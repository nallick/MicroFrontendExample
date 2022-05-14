//
//  PickerServiceTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

@testable import PickerService

import BaseSwiftMocks
import CommonTypes
import XCTest

final class PickerServiceTests: XCTestCase {
    let userDefaults = UserDefaults.test

    override func tearDown() {
        userDefaults.removeAllValues()
    }

    func testInitializedServiceBecomesSharedSingleton() {
        let service1 = PickerService()
        XCTAssert(service1 === PickerService.shared)

        let service2 = PickerService(userDefaults: userDefaults)
        XCTAssert(service2 === PickerService.shared)
    }

    func testAttemptCountUsesUserDefaults() throws {
        var expectedValue = 123
        userDefaults.set(expectedValue, forKey: PickerService.attemptCountKey)

        let service = PickerService(userDefaults: userDefaults)
        XCTAssertEqual(service.attemptCount, expectedValue)

        service.incrementAttemptCount()
        expectedValue += 1
        XCTAssertEqual(service.attemptCount, expectedValue)
        XCTAssertEqual(userDefaults.integer(forKey: PickerService.attemptCountKey), expectedValue)
    }

    func testApplicationDidFinishLaunchingReturnsTrueWhenUserDefaultsIsAvailable() {
        let service = PickerService(userDefaults: userDefaults)
        let actualResult = service.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(actualResult)
    }

    func testApplicationDidFinishLaunchingReturnsFalseWhenUserDefaultsIsNotAvailable() {
        let service = PickerService(userDefaults: nil)
        let actualResult = service.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertFalse(actualResult)
    }

    func testWorkflowProviderDecodableTypes() {
        let service = PickerService()
        let expectedResult = [PickerViewController.self]
        let actualResult = service.workflowDecodableTypes()
        XCTAssertEqual(actualResult.count, expectedResult.count)
        XCTAssertEqual(ObjectIdentifier(actualResult.first!), ObjectIdentifier(expectedResult.first!))  // we can't compare metatypes directly
    }

    func testAttemptResetNotificationRemovesAttemptsFromUserDefaults() {
        let notificationCenter = NotificationCenter()
        userDefaults.set(1, forKey: PickerService.attemptCountKey)
        _ = PickerService(notificationCenter: notificationCenter, userDefaults: userDefaults)

        notificationCenter.post(name: .resetAttemptsAndStatistics, object: nil)

        let attemptValue = userDefaults.object(forKey: PickerService.attemptCountKey)
        XCTAssertNil(attemptValue)
    }
}
