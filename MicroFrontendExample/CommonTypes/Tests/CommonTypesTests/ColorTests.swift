//
//  ColorTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import CommonTypes
import XCTest

final class ColorTests: XCTestCase {

    func testRawValues() {
        let rawValues = [0, 1, 2, 3]
        let expectedValues = [Color.red, .green, .blue, nil]

        let actualValues = rawValues.map { Color(rawValue: $0) }

        XCTAssertEqual(actualValues, expectedValues)
    }

    func testNames() {
        let testValues = [Color.red, .green, .blue]
        let expectedValues = ["Red", "Green", "Blue"]

        let actualValues = testValues.map { $0.name }

        XCTAssertEqual(actualValues, expectedValues)
    }

    func testValues() {
        let testValues = [Color.red, .green, .blue]
        let expectedValues = [UIColor.red, .green, .blue]

        let actualValues = testValues.map { $0.value }

        XCTAssertEqual(actualValues, expectedValues)
    }
}
