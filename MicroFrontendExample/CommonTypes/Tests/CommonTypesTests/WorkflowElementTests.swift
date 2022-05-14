//
//  WorkflowElementTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import CommonTypes
import XCTest

final class WorkflowElementTests: XCTestCase {

    func testRawValues() {
        let rawValues = ["picker", "reveal"]
        let expectedValues = [WorkflowElement.picker, .reveal]

        let actualValues = rawValues.map { WorkflowElement(rawValue: $0) }

        XCTAssertEqual(actualValues, expectedValues)
    }

    func testCompleteness() {
        let testValue = WorkflowElement(rawValue: "picker")
        var switchIsExhaustive = false

        // if this test compiles it will pass, otherwise there are new unexpected enum values
        switch testValue {
            case .picker, .reveal:
                fallthrough
            case .none:
                switchIsExhaustive = true
        }

        XCTAssertTrue(switchIsExhaustive)
    }
}
