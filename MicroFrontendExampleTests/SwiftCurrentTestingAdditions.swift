//
//  SwiftCurrentTestingAdditions.swift
//

import SwiftCurrent
import SwiftCurrent_Testing
import XCTest

//  This is a type-erased version of the generic function provided by SwiftCurrent.
//  See XCTAssertWorkflowLaunched<F>() in SwiftCurrent_Testing.CustomAssertions.swift.
//
public func XCTAssertWorkflowLaunched(from VC: UIViewController, workflow: AnyWorkflow?, file: StaticString = #filePath, line: UInt = #line) {
    let last = VC.launchedWorkflows.last
    guard let workflow = workflow else {
        XCTAssertNil(last, "workflow found when none expected", file: file, line: line)
        return
    }
    XCTAssertNotNil(last, "No workflow found", file: file, line: line)
    guard let listenerWorkflow = last,
          listenerWorkflow.count == workflow.count else {
        XCTFail("workflow does not contain correct representables", file: file, line: line)
        return
    }

    for node in listenerWorkflow {
        let actual = node.value.metadata.flowRepresentableTypeDescriptor
        guard let workflowNode = workflow.first?.traverse(node.position) else {
            XCTFail("expected workflow not as long as actual workflow", file: file, line: line)
            return
        }
        let expected = workflowNode.value.metadata.flowRepresentableTypeDescriptor
        XCTAssert(actual == expected, "Expected type: \(expected), but got: \(actual)", file: file, line: line)
    }
}
