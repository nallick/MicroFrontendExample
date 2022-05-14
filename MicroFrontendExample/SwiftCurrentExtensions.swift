//
//  SwiftCurrentExtensions.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import CommonTypes
import Foundation
import SwiftCurrent
import SwiftCurrent_UIKit
import UIKit

extension AnyWorkflow {

    private struct WorkflowElementAggregator: FlowRepresentableAggregator {
        let types: [WorkflowDecodable.Type]

        static let allWorkflowDecodables: [WorkflowDecodable.Type] = {
            let workflowProviders = ApplicationDelegate.shared?.services(conformingTo: WorkflowProvider.self) ?? []
            return workflowProviders.flatMap { $0.workflowDecodableTypes() }
        }()

        init() {
            self.init([])
        }

        init(_ elements: [WorkflowElement]) {
            types = Self.allWorkflowDecodables.filter { type in elements.contains(where: { $0.rawValue == type.flowRepresentableName }) }
        }
    }

    //  Exploit SwiftCurrent's data driven workflow feature to create an AnyWorkflow from FlowRepresentable types that aren't known at compile time.
    //  We don't know the types because we're purposely not importing the modules that define them in order to remain loosely coupled.
    //  However this circumvents SwiftCurrent's workflow compile-time type checking, so we want to ensure we're providing workflow elements with compatible inputs and outputs.
    //  In theory, this could be checked at runtime, or in unit tests, through reflection or with UI tests (but this is left as an exercise for the reader).
    //
    public static func with(elements: [WorkflowElement], launchStyle: LaunchStyle.PresentationType = .navigationStack) -> AnyWorkflow? {
        guard !elements.isEmpty else { return nil }

        let workflowJSON = #"{"$schema": "https://raw.githubusercontent.com/wwt/WorkflowSchema/main/workflow-schema.json", "schemaVersion": "v0.0.1", "sequence": ["# +
                            elements.reduce(into: "") { $0.append(#"{"flowRepresentableName": "\#($1)", "launchStyle": "\#(launchStyle)"}, "#) } +
                            "]}"
        guard let workflowData = workflowJSON.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decodeWorkflow(withAggregator: WorkflowElementAggregator(elements), from: workflowData)
    }
}
