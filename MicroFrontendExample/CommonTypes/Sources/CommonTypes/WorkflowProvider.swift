//
//  WorkflowProvider.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Foundation
import SwiftCurrent

public protocol WorkflowProvider {

    func workflowDecodableTypes() -> [WorkflowDecodable.Type]
}
