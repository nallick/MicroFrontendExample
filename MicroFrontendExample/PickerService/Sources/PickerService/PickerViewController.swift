//
//  PickerViewController.swift
//
//  Copyright © 2022 Purgatory Design. Licensed under the MIT License.
//

import CommonTypes
import Foundation
import SwiftCurrent
import SwiftCurrent_UIKit
import UIKit

final internal class PickerViewController: UIWorkflowItem<Never, Color> {

    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet var attemptCountLabel: UILabel!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @IBAction func pickColor(sender: UIButton) {
        guard let color = Color(rawValue: sender.tag) else { return }
        PickerService.shared.incrementAttemptCount()
        proceedInWorkflow(color)
    }

    @IBAction func resetAttemptsAndStatistics() {
        PickerService.shared.notificationCenter.post(name: .resetAttemptsAndStatistics, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        colorButtons.forEach { button in
            button.backgroundColor = Color(rawValue: button.tag)?.value
        }

        PickerService.shared.notificationCenter.addObserver(forName: .resetAttemptsAndStatistics, object: nil, queue: nil) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateAttemptCountLabel()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAttemptCountLabel()
    }

    private func updateAttemptCountLabel() {
        attemptCountLabel.text = "\(PickerService.shared.attemptCount)"
    }
}

extension PickerViewController: StoryboardLoadable {

    static let storyboardName = "Picker"
    static var storyboardId: String { String(describing: Self.self) }
    static var storyboard: UIStoryboard { UIStoryboard(name: storyboardName, bundle: Bundle.module) }
}

extension PickerViewController: WorkflowDecodable {

    static var flowRepresentableName = WorkflowElement.picker.rawValue
}
