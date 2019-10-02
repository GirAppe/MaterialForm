//
//  MaterialTextFieldStyle.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 30/09/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

// MARK: - Interface

public protocol MaterialField: class {
    var fieldState: FieldControlState { get }
    var isShowingError: Bool { get }
    var isEnabled: Bool { get }
    var isDisabled: Bool { get }
}

public extension MaterialField {
    var isDisabled: Bool { return !isEnabled }
}

public protocol MaterialTextFieldStyle {
    var maxLineWidth: CGFloat { get }

    func lineWidth(for field: MaterialField) -> CGFloat
    func lineColor(for field: MaterialField) -> UIColor
    func placeholderColor(for field: MaterialField) -> UIColor
    func textColor(for field: MaterialField) -> UIColor
    func infoColor(for field: MaterialField) -> UIColor
    func backgroundColor(for field: MaterialField) -> UIColor
}

// MARK: - Default implementation

class DefaultMaterialTextFieldStyle {

    var errorLineWidth: CGFloat = 2
    var errorColor: UIColor = .red
    var infoColor: UIColor = .gray
    var focusedColor: UIColor = .blue
    var backgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.4)

    var lineWidths: [FieldControlState: CGFloat] = [.focused: 2, .filled: 1]
    var lineColors: [FieldControlState: UIColor] = [:]
    var colors: [FieldControlState: UIColor] = [:]
    var placeholderColors: [FieldControlState: UIColor] = [:]

    var defaultWidth: CGFloat = 0
    var defaultColor: UIColor = .darkText
    var defaultPlaceholderColor: UIColor = .darkText
}

extension DefaultMaterialTextFieldStyle: MaterialTextFieldStyle {

    var maxLineWidth: CGFloat {
        return lineWidths.values.reduce(into: 0) { $0 = max($0, $1) }
    }

    func lineWidth(for field: MaterialField) -> CGFloat {
        guard !field.isShowingError else { return errorLineWidth }
        return lineWidths[field.fieldState] ?? defaultWidth
    }

    func lineColor(for field: MaterialField) -> UIColor {
        guard !field.isShowingError else { return errorColor }
        if field.fieldState == .focused {
            return focusedColor
        }
        return lineColors[field.fieldState] ?? defaultColor
    }

    func placeholderColor(for field: MaterialField) -> UIColor {
        guard !field.isShowingError else { return errorColor }
        if field.fieldState == .focused {
            return focusedColor
        }
        return placeholderColors[field.fieldState] ?? defaultPlaceholderColor
    }

    func textColor(for field: MaterialField) -> UIColor {
        guard !field.isShowingError else { return errorColor }
        return colors[field.fieldState] ?? defaultColor
    }

    func infoColor(for field: MaterialField) -> UIColor {
        guard !field.isShowingError else { return errorColor }
        return infoColor
    }

    func backgroundColor(for field: MaterialField) -> UIColor {
        return backgroundColor
    }
}
