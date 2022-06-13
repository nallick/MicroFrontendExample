//
//  RevealService.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import Apollo
import CommonTypes
import CoreData
import Foundation
import SwiftCurrent
import UIKit

public final class RevealService {
    internal let notificationCenter: NotificationCenter
    private let coreDataContext: ServiceCoreDataContext<RevealService>
    private var coreDataContextLoaded = false

    public private(set) static var shared: RevealService!

    convenience public init() {
        self.init(persistentContainer: nil)
    }

    public init(notificationCenter: NotificationCenter = .default, persistentContainer: NSPersistentContainer?) {
        self.notificationCenter = notificationCenter
        self.coreDataContext = ServiceCoreDataContext(bundle: Bundle.module, persistentContainer: persistentContainer)
        Self.shared = self

        notificationCenter.addObserver(forName: .resetAttemptsAndStatistics, object: nil, queue: nil) { [weak self] _ in
            self?.resetStatistics()
        }
    }

    internal func incrementedStatistics(for color: Color) throws -> Statistics {
        let statistics = fetchStatistics()
        switch color {
            case .red: statistics.red += 1
            case .green: statistics.green += 1
            case .blue: statistics.blue += 1
        }

        try coreDataContext.saveDatabaseContext()

        return statistics
    }

    internal func fetchStatistics() -> Statistics {
        if !coreDataContextLoaded { fatalError("CoreData not loaded: \(Self.name)") }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Statistics.self))
        fetchRequest.fetchLimit = 1

        let fetchedStatistics = try? coreDataContext.managedObjectContext.fetch(fetchRequest) as? [Statistics]
        return fetchedStatistics?.first ?? Statistics(context: coreDataContext.managedObjectContext)
    }

    internal func loadPersistentStores(completion: @escaping (Bool) -> Void) {
        if coreDataContextLoaded { completion(true); return }

        coreDataContext.loadPersistentStores { [weak self] _, error in
            let success = error == nil
            self?.coreDataContextLoaded = success
            completion(success)
        }
    }

    private func resetStatistics() {
        let statistics = fetchStatistics()
        coreDataContext.persistentContainer.viewContext.delete(statistics)
        try? coreDataContext.saveDatabaseContext()
    }
}

extension RevealService: Apollo.ServiceModule {

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadPersistentStores { success in
            if !success { fatalError("CoreData unavailable for: \(Self.name)") }
        }
        return true
    }
}

extension RevealService: WorkflowProvider {

    public func workflowDecodableTypes() -> [WorkflowDecodable.Type] {
        [RevealViewController.self]
    }
}
