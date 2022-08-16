//
//  WorkflowNavigationControllerTests.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import MicroFrontendExample

import SwiftCurrent
import SwiftCurrent_Testing
import UIUTest
import XCTest

final class WorkflowNavigationControllerTests: XCTestCase {

    func testWorkflowElementsExist() {
        XCTAssertNotNil(AnyWorkflow.with(elements: WorkflowNavigationController.workflowElements))
    }

    func testNavigationControllerLaunchesIntoExpectedWorkflow() {
        let navigationController = WorkflowNavigationController()
        navigationController.viewDidLoad()

        flushDispatchQueue(.main, timeout: 1.0)

        XCTAssertWorkflowLaunched(from: navigationController, workflow: AnyWorkflow.with(elements: WorkflowNavigationController.workflowElements))
    }
}
