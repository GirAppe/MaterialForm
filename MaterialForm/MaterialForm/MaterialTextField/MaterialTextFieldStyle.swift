//
//  MaterialTextFieldStyle.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 30/09/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

// MARK: - Interface

public protocol MaterialTextFieldStyle {

    // Getters

    func lineWidth(for state: FieldControlState, error: Bool) -> CGFloat
    func lineColor(for state: FieldControlState, error: Bool) -> UIColor
    func placeholderColor(for state: FieldControlState, error: Bool) -> UIColor
    func textColor(for state: FieldControlState, error: Bool) -> UIColor

    // Setters

    // TODO: Implemtn
}

internal extension MaterialTextFieldStyle {

    var maxLineWidth: CGFloat {
        return FieldControlState.allCases.reduce(0) { result, state -> CGFloat in
            let currentWithError = lineWidth(for: state, error: true)
            let currentWithoutError = lineWidth(for: state, error: false)
            let current = max(currentWithError, currentWithoutError)
            return max(result, current)
        }
    }
}

// MARK: - Default implementation

class DefaultMaterialTextFieldStyle: MaterialTextFieldStyle {

    var errorLineWidth: CGFloat = 2
    var errorColor: UIColor = .red
    var lineWidths: [FieldControlState: CGFloat] = [.focused: 2]
    var lineColors: [FieldControlState: UIColor] = [:]
    var colors: [FieldControlState: UIColor] = [:]
    var placeholderColors: [FieldControlState: UIColor] = [:]

    var defaultWidth: CGFloat = 1
    var defaultColor: UIColor = .darkText
    var defaultPlaceholderColor: UIColor = .darkText

    func lineWidth(for state: FieldControlState, error: Bool) -> CGFloat {
        guard !error else { return errorLineWidth }
        return lineWidths[state] ?? defaultWidth
    }

    func lineColor(for state: FieldControlState, error: Bool) -> UIColor {
        guard !error else { return errorColor }
        return lineColors[state] ?? defaultColor
    }

    func placeholderColor(for state: FieldControlState, error: Bool) -> UIColor {
        guard !error else { return errorColor }
        return placeholderColors[state] ?? defaultPlaceholderColor
    }

    func textColor(for state: FieldControlState, error: Bool) -> UIColor {
        guard !error else { return errorColor }
        return colors[state] ?? defaultColor
    }
}
