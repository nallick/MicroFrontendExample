//
//  RevealViewController.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import CommonTypes
import Foundation
import SwiftCurrent
import SwiftCurrent_UIKit
import UIKit

final internal class RevealViewController: UIWorkflowItem<Color, Never> {
    private let pick: Color

    @IBOutlet private var sampleViews: [UIView]!
    @IBOutlet private var choiceLabel: UILabel!
    @IBOutlet private var redCountLabel: UILabel!
    @IBOutlet private var greenCountLabel: UILabel!
    @IBOutlet private var blueCountLabel: UILabel!

    required init?(coder: NSCoder) { fatalError() }

    required init?(coder: NSCoder, with pick: Color) {
        self.pick = pick
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        choiceLabel.text = "Your color is \(pick.name)!"

        if let statistics = try? RevealService.shared.incrementedStatistics(for: pick) {
            updateStatisticsLabels(with: statistics)
        }

        RevealService.shared.notificationCenter.addObserver(forName: .resetAttemptsAndStatistics, object: nil, queue: nil) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateStatisticsLabels(with: RevealService.shared.fetchStatistics())
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.sampleViews.forEach { view in
            view.layer.cornerRadius = 0.5 * view.frame.width
            view.backgroundColor = self.pick.value
        }

        UIView.animate(withDuration: 1.0) {
            self.sampleViews.forEach { view in
                view.alpha = 0.5
            }
        }
    }

    private func updateStatisticsLabels(with statistics: Statistics) {
        redCountLabel.text = "\(statistics.red)"
        greenCountLabel.text = "\(statistics.green)"
        blueCountLabel.text = "\(statistics.blue)"
    }
}

extension RevealViewController: StoryboardLoadable {

    static var storyboardId: String { String(describing: Self.self) }
    static var storyboard: UIStoryboard { UIStoryboard(name: "Reveal", bundle: Bundle.module) }
}

extension RevealViewController: WorkflowDecodable {

    static var flowRepresentableName = WorkflowElement.reveal.rawValue
}
