#if canImport(UIKit)

import UIKit

// MARK: - Default implementation

@available(iOS 10, *)
class DefaultMaterialTextFieldStyle: MaterialTextFieldStyle {

    var errorLineWidth: CGFloat = 2
    var errorColor: UIColor = .red
    var infoColor: UIColor = .gray
    var focusedColor: UIColor = .blue
    var backgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.4)
    var insets = UIEdgeInsets(top: 10, left: 12, bottom: 0, right: 12) 

    var lineWidths: [FieldControlState: CGFloat] = [.focused: 2, .filled: 1]
    var lineColors: [FieldControlState: UIColor] = [:]
    var colors: [FieldControlState: UIColor] = [:]
    var placeholderColors: [FieldControlState: UIColor] = [:]

    var defaultRadius: CGFloat = 6
    var defaultWidth: CGFloat = 0

    #if os(iOS)
    var defaultColor: UIColor = .darkText
    var defaultPlaceholderColor: UIColor = .darkText
    #elseif os(tvOS)
    var defaultColor: UIColor = .black
    var defaultPlaceholderColor: UIColor = .darkGray
    #endif

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

    func borderWidth(for state: MaterialFieldState) -> CGFloat {
        return 0
    }

    func borderColor(for state: MaterialFieldState) -> UIColor {
        return .clear
    }

    func left(
        accessory: MaterialUITextField.Accessory,
        for state: MaterialFieldState
    ) -> AccessoryState {
        return accessoryState(accessory, for: state)
    }

    func right(
        accessory: MaterialUITextField.Accessory,
        for state: MaterialFieldState
    ) -> AccessoryState {
        return accessoryState(accessory, for: state)
    }

    private func accessoryState(
        _ accessory: MaterialUITextField.Accessory,
        for state: MaterialFieldState
    ) -> AccessoryState {
        switch accessory {
        case .error where state.isShowingError:
            return AccessoryState(tintColor: errorColor, isHidden: false)
        case .error:
            return AccessoryState(tintColor: .clear, isHidden: true)
        case .action:
            return AccessoryState(tintColor: focusedColor, isHidden: false)
        case .info:
            return AccessoryState(tintColor: defaultColor, isHidden: false)
        case .none:
            return AccessoryState(tintColor: .clear, isHidden: true)
        default:
            return AccessoryState(tintColor: focusedColor, isHidden: false)
        }
    }
}

#endif
