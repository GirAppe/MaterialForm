//
//  ViewController.swift
//  SampleApp
//
//  Created by Andrzej Michnia on 03/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit
import MaterialForm

class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var field: MaterialTextField!
    @IBOutlet weak var infoTextField: MaterialTextField!
    @IBOutlet weak var maxCharactersField: MaterialTextField!
    @IBOutlet weak var borderType: UISegmentedControl!

    @IBOutlet weak var eventsView: UITextView!
    @IBOutlet weak var stateLabel: UILabel!

    // MARK: - Properties

    var observations: [Any] = []
    var events: [String] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupObservers()
    }

    // MARK: - Setup

    func setupObservers() {
        observations.append(maxCharactersField.observe(\.text) { [weak self] it, _ in
            guard let text = it.text else { return it.errorMessage = nil }
            guard let count = Int(text) else { return it.errorMessage = "Must be a valid number!" }
            guard count >= 0 else { return it.errorMessage = "Must be zero or grerater!" }

            it.errorMessage = nil
            self?.field.maxCharactersCount = count
        })
        observations.append(field.observe(\.fieldState) { [weak self] it, _ in
            self?.stateLabel.text = "\(it.fieldState.description)"
        })
        observations.append(field.observe(\.event) { [weak self] it, _ in
            self?.events.insert("\(it.event.description)", at: 0)
            guard let events = self?.events else { return }
            self?.eventsView.text = events.joined(separator: "\n")
        })
        observations.append(infoTextField.observe(\.text) { [weak self] it, _ in
            self?.field.infoMessage = it.text
        })
    }

    // MARK: - Actions

    @IBAction func toggleError(_ sender: UISwitch) {
        if sender.isOn {
            field.errorMessage = "Form validation error!"
        } else {
            field.errorMessage = nil
        }
    }

    @IBAction func toggleEditingEnabled(_ sender: UISwitch) {
        field.isEditingEnabled = sender.isOn
    }

    @IBAction func toggleCharacterCount(_ sender: UISwitch) {
        field.showCharactersCounter = sender.isOn
    }

    @IBAction func toggleExtendLineUnderAccessory(_ sender: UISwitch) {
        field.extendLineUnderAccessory = sender.isOn
    }

    @IBAction func borderTypeChanged(_ sender: UISegmentedControl) {
        guard let border = UITextField.BorderStyle(rawValue: sender.selectedSegmentIndex) else {
            return
        }

        field.borderStyle = border
    }

    @IBAction func leftAccessoryChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            let customView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
            customView.backgroundColor = .red
            field.leftAccessory = .view(customView)
        case 2:
            field.leftAccessory = .info(UIImage(named: "show")!)
        case 3:
            field.leftAccessory = .error(UIImage(named: "show")!.withRenderingMode(.alwaysTemplate))
        case 4:
            field.leftAccessory = .action(UIImage(named: "show")!.withRenderingMode(.alwaysTemplate))
        default:
            field.leftAccessory = .none
        }
    }

    @IBAction func roghtAccessoryChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            let customView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
            customView.backgroundColor = .red
            field.rightAccessory = .view(customView)
        case 2:
            field.rightAccessory = .info(UIImage(named: "show")!)
        case 3:
            field.rightAccessory = .error(UIImage(named: "show")!.withRenderingMode(.alwaysTemplate))
        case 4:
            field.rightAccessory = .action(UIImage(named: "show")!.withRenderingMode(.alwaysTemplate))
        default:
            field.rightAccessory = .none
        }
    }

    @IBAction func clearFromCode() {
        field.text = nil
    }

    @IBAction func setFromCode() {
        field.text = "This is text"
    }
}
