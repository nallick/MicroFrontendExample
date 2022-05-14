//
//  SwiftCurrentExtensionTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import MicroFrontendExample

import SwiftCurrent
import XCTest

final class SwiftCurrentExtensionTests: XCTestCase {

    func testCreateAnyWorkflowFromWorkflowElements() {
        let workflow = AnyWorkflow.with(elements: [.picker, .reveal])
        XCTAssertNotNil(workflow)
        XCTAssertEqual(workflow?.count, 2)
        XCTAssertEqual(workflow?.first?.value.metadata.flowRepresentableTypeDescriptor, "PickerViewController")
        XCTAssertEqual(workflow?.last?.value.metadata.flowRepresentableTypeDescriptor, "RevealViewController")
    }
}
