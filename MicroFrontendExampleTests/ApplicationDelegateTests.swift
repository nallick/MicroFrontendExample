//
//  ApplicationDelegateTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Apollo
import MicroFrontendExample

import XCTest

protocol TestableService {}

final class ApplicationDelegateTests: XCTestCase {

    func testSingletonIsApplicationDelegate() {
        XCTAssert(ApplicationDelegate.shared === UIApplication.shared.delegate)
        XCTAssertNotNil(ApplicationDelegate.shared)
    }

    func testServicesConformTo() {
        let applicationDelegate = ApplicationDelegate()

        let allServiceTypes = applicationDelegate.services(conformingTo: ServiceModule.self).map { type(of: $0) }
        XCTAssertTrue(allServiceTypes.contains { ObjectIdentifier($0) == ObjectIdentifier(TestService1.self) })
        XCTAssertTrue(allServiceTypes.contains { ObjectIdentifier($0) == ObjectIdentifier(TestService2.self) })

        let testableServiceTypes = applicationDelegate.services(conformingTo: TestableService.self).map { type(of: $0) }
        XCTAssertTrue(testableServiceTypes.contains { ObjectIdentifier($0) == ObjectIdentifier(TestService1.self) })
        XCTAssertFalse(testableServiceTypes.contains { ObjectIdentifier($0) == ObjectIdentifier(TestService2.self) })
    }
}

extension ApplicationDelegateTests {

    final class TestService1: ServiceModule, TestableService {}
    final class TestService2: ServiceModule {}
}
