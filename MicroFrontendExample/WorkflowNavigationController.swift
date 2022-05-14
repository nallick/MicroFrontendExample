//
//  WorkflowNavigationController.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import CommonTypes
import Foundation
import SwiftCurrent
import UIKit

//  This navigation controller is instantiated at launch by the main storyboard and simply launches into our SwiftCurrent workflow.
//
public final class WorkflowNavigationController: UINavigationController {
    public static let workflowElements = [WorkflowElement.picker, .reveal]

    public override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            guard let workflow = AnyWorkflow.with(elements: Self.workflowElements) else { return }    // NOTE: this circumvents SwiftCurrent's workflow compile-time type checking
            self.launchInto(workflow, withLaunchStyle: .default)
        }
    }
}
