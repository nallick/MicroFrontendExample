//
//  Color.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Foundation
import UIKit

public enum Color: Int {

    case red, green, blue

    public var name: String { "\(self)".capitalized }

    public var value: UIColor {
        switch self {
            case .red: return .red
            case .green: return .green
            case .blue: return .blue
        }
    }
}

extension Color: CaseIterable {}
