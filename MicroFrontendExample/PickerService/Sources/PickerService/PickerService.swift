//
//  PickerService.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Apollo
import CommonTypes
import Foundation
import SwiftCurrent
import UIKit

public final class PickerService {
    internal let notificationCenter: NotificationCenter
    private let userDefaults: UserDefaults!

    public private(set) static var shared: PickerService!
    internal static let attemptCountKey = "AttemptCount"

    internal var attemptCount: Int {
        userDefaults.integer(forKey: Self.attemptCountKey)
    }

    convenience public init() {
        self.init(userDefaults: Self.userDefaults)  // from Apollo.ServiceModule.userDefaults
    }

    public init(notificationCenter: NotificationCenter = .default, userDefaults: UserDefaults?) {
        self.notificationCenter = notificationCenter
        self.userDefaults = userDefaults
        Self.shared = self

        notificationCenter.addObserver(forName: .resetAttemptsAndStatistics, object: nil, queue: nil) { [weak self] _ in
            self?.resetAttempts()
        }
    }

    internal func incrementAttemptCount() {
        let incrementedAttemptCount = attemptCount + 1
        userDefaults.set(incrementedAttemptCount, forKey: Self.attemptCountKey)
    }

    private func resetAttempts() {
        userDefaults.removeObject(forKey: Self.attemptCountKey)
    }
}

extension PickerService: Apollo.ServiceModule {

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let userDefaultsAvailable = userDefaults != nil
        if !userDefaultsAvailable { print("UserDefaults unavailable for: \(Self.name)") }
        return userDefaultsAvailable
    }
}

extension PickerService: WorkflowProvider {

    public func workflowDecodableTypes() -> [WorkflowDecodable.Type] {
        [PickerViewController.self]
    }
}
