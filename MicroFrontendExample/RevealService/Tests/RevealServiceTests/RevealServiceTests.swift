//
//  RevealServiceTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

@testable import RevealService

import BaseSwiftMocks
import CommonTypes
import XCTest

final class RevealServiceTests: XCTestCase {

    func testInitializedServiceBecomesSharedSingleton() {
        let service1 = RevealService()
        XCTAssert(service1 === RevealService.shared)

        let service2 = RevealService(persistentContainer: nil)
        XCTAssert(service2 === RevealService.shared)
    }

    func testStatisticsCanBeFetchedAnIncremented() throws {
        var expectedValues = [Int64(0), 0, 0]
        let service = makeTestRevealService()

        func assertFetchedStatisticsAreAsExpected() {
            let statistics = service.fetchStatistics()
            XCTAssertEqual(statistics.red, expectedValues[Color.red.rawValue])
            XCTAssertEqual(statistics.green, expectedValues[Color.green.rawValue])
            XCTAssertEqual(statistics.blue, expectedValues[Color.blue.rawValue])
        }

        func assertIncrementedStatisticsAreAsExpected(incrementing color: Color) throws {
            let statistics = try service.incrementedStatistics(for: color)
            expectedValues[color.rawValue] += 1
            XCTAssertEqual(statistics.red, expectedValues[Color.red.rawValue])
            XCTAssertEqual(statistics.green, expectedValues[Color.green.rawValue])
            XCTAssertEqual(statistics.blue, expectedValues[Color.blue.rawValue])
        }

        assertFetchedStatisticsAreAsExpected()

        try assertIncrementedStatisticsAreAsExpected(incrementing: .red)
        try assertIncrementedStatisticsAreAsExpected(incrementing: .green)
        try assertIncrementedStatisticsAreAsExpected(incrementing: .blue)

        assertFetchedStatisticsAreAsExpected()
    }

    func testApplicationDidFinishLaunchingReturnsTrue() {
        let service = makeTestRevealService()
        let actualResult = service.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(actualResult)
    }

    func testWorkflowProviderDecodableTypes() {
        let service = makeTestRevealService()
        let expectedResult = [RevealViewController.self]
        let actualResult = service.workflowDecodableTypes()
        XCTAssertEqual(actualResult.count, expectedResult.count)
        XCTAssertEqual(ObjectIdentifier(actualResult.first!), ObjectIdentifier(expectedResult.first!))  // we can't compare metatypes directly
    }

    func testStatisticsResetNotificationRemovesStatisticsFromCoreData() {
        let notificationCenter = NotificationCenter()
        let service = makeTestRevealService(notificationCenter: notificationCenter)

        notificationCenter.post(name: .resetAttemptsAndStatistics, object: nil)
        let statistics = service.fetchStatistics()

        XCTAssertEqual(statistics.red, 0)
        XCTAssertEqual(statistics.green, 0)
        XCTAssertEqual(statistics.blue, 0)
    }
}

extension XCTestCase {

    func makeTestRevealService(notificationCenter: NotificationCenter = .default) -> RevealService {
        let result = RevealService(notificationCenter: notificationCenter, persistentContainer: Self.memoryResidentPersistentContainer(containerName: "RevealService", bundle: Bundle.module))

        let expectation = expectation(description: "Awaiting CoreData")
        var dataLoaded = false
        result.loadPersistentStores { success in
            dataLoaded = success
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(dataLoaded)

        return result
    }
}
