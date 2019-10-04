//
//  DefaultMaterialTextFieldState.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 04/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

// MARK: - Default implementation

class DefaultMaterialTextFieldStyle: MaterialTextFieldStyle {

    var errorLineWidth: CGFloat = 2
    var errorColor: UIColor = .red
    var infoColor: UIColor = .gray
    var focusedColor: UIColor = .blue
    var backgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.4)

    var lineWidths: [FieldControlState: CGFloat] = [.focused: 2, .filled: 1]
    var lineColors: [FieldControlState: UIColor] = [:]
    var colors: [FieldControlState: UIColor] = [:]
    var placeholderColors: [FieldControlState: UIColor] = [:]

    var defaultRadius: CGFloat = 6
    var defaultWidth: CGFloat = 0
    var defaultColor: UIColor = .darkText
    var defaultPlaceholderColor: UIColor = .darkText

    // MARK: - Style

    var maxLineWidth: CGFloat {
        return lineWidths.values.reduce(into: 0) { $0 = max($0, $1) }
    }

    var cornerRadius: CGFloat {
        get { return defaultRadius }
        set { defaultRadius = newValue }
    }

    func lineWidth(for state: MaterialFieldState) -> CGFloat {
        guard !state.isShowingError else { return errorLineWidth }
        return lineWidths[state.fieldState] ?? defaultWidth
    }

    func lineColor(for state: MaterialFieldState) -> UIColor {
        guard !state.isShowingError else { return errorColor }
        if state.fieldState == .focused {
            return focusedColor
        }
        return lineColors[state.fieldState] ?? defaultColor
    }

    func placeholderColor(for state: MaterialFieldState) -> UIColor {
        guard !state.isShowingError else { return errorColor }
        if state.fieldState == .focused {
            return focusedColor
        }
        return placeholderColors[state.fieldState] ?? defaultPlaceholderColor
    }

    func textColor(for state: MaterialFieldState) -> UIColor {
        guard !state.isShowingError else { return errorColor }
        return colors[state.fieldState] ?? defaultColor
    }

    func infoColor(for state: MaterialFieldState) -> UIColor {
        guard !state.isShowingError else { return errorColor }
        return infoColor
    }

    func backgroundColor(for state: MaterialFieldState) -> UIColor {
        return backgroundColor
    }

    func showsBackgorund(for state: MaterialFieldState) -> Bool {
        return true
    }

    func borderWidth(for state: MaterialFieldState) -> CGFloat {
        return 0
    }

    func borderColor(for state: MaterialFieldState) -> UIColor {
        return .clear
    }
}
