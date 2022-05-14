//
//  ApplicationDelegate.swift
//
//  We're mostly using the application delegate provided by Apollo, which provides a ServicesHost and handles application lifecycle events.
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Apollo
import CommonTypes
import UIKit

@main
public final class ApplicationDelegate: ApolloApplicationDelegate {

    public static var shared: ApplicationDelegate? { UIApplication.shared.delegate as? ApplicationDelegate }

    public func services<T>(conformingTo type: T.Type) -> [T] {
        servicesHost.services(conformingTo: type)
    }

    // MARK: UISceneSession Lifecycle

    public func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
