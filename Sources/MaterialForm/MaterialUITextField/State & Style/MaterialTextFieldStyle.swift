#if canImport(UIKit)

import UIKit

// MARK: - Text Field State

@available(iOS 10, *)
public protocol MaterialTextFieldStyle: class {

    var maxLineWidth: CGFloat { get }
    var cornerRadius: CGFloat { get set }

    func lineWidth(for state: MaterialFieldState) -> CGFloat
    func lineColor(for state: MaterialFieldState) -> UIColor

    func placeholderColor(for state: MaterialFieldState) -> UIColor
    func infoColor(for state: MaterialFieldState) -> UIColor

    func backgroundColor(for state: MaterialFieldState) -> UIColor

    func borderWidth(for state: MaterialFieldState) -> CGFloat
    func borderColor(for state: MaterialFieldState) -> UIColor

    func left(accessory: MaterialUITextField.Accessory, for state: MaterialFieldState) -> AccessoryState
    func right(accessory: MaterialUITextField.Accessory, for state: MaterialFieldState) -> AccessoryState
}

// MARK: - Accessory State

@available(iOS 10, *)
public struct AccessoryState {
    let tintColor: UIColor
    let isHidden: Bool
}

#endif
