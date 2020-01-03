#if canImport(UIKit)

import UIKit

// MARK: - Default implementation

@available(iOS 10, *)
/// Default implementation of Material Text Field style.
public class DefaultMaterialTextFieldStyle: MaterialTextFieldStyle, ConfigurableTextFieldStyle {

    /// Underline width when showing error
    public var errorLineWidth: CGFloat = 2
    /// Accent / tint color used when showing error
    public var errorColor: UIColor = .red
    /// Color used for info message and character counter
    public var infoColor: UIColor = .gray
    /// Accent/tint color used when field is `focused`
    public var focusedColor: UIColor = .blue
    /// Field background color. Default is gray with 40% opacity
    public var backgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.4)
    /// Field internal insets.
    public var insets = UIEdgeInsets(top: 10, left: 12, bottom: 0, right: 12)
    /// [Lookup table] Maps field state into underline thickness. If not specified, state would map to `defaultLineWidth`
    public var lineWidths: [FieldControlState: CGFloat] = [.focused: 2, .filled: 1]
    /// [Lookup table] Maps field state into underline color. If not specified, state would map to `defaultColor`
    public var lineColors: [FieldControlState: UIColor] = [:]
    /// [Lookup table] Maps field state into plaeholder floating label color. If not specified, state would map to `defaultColor`
    public var placeholderColors: [FieldControlState: UIColor] = [:]
    /// Default underline thickness. Would be used if there is no value specified in the `lineWidths` lookup table.
    var defaultLineWidth: CGFloat = 0

    #if os(iOS)
    /// Default color used for line and `.info` accessories, if no value specified for given field state
    public var defaultColor: UIColor = .darkText
    /// Default color used for placeholder floating label, if no value specified for given field state
    public var defaultPlaceholderColor: UIColor = .darkText
    #elseif os(tvOS)
    /// Default color used for line and `.info` accessories, if no value specified for given field state
    public var defaultColor: UIColor = .black
    /// Default color used for placeholder floating label, if no value specified for given field state
    public var defaultPlaceholderColor: UIColor = .darkGray
    #endif

    /// Default corner radius used with `bezel` and `rounded` styles.
    public var cornerRadius: CGFloat = 6

    // MARK: - Style

    /// [Internal] used to prepare correct layout for line changes. Should return thickest line width possible.
    public var maxLineWidth: CGFloat {
        return lineWidths.values.reduce(into: 0) { $0 = max($0, $1) }
    }

    public func lineWidth(for state: MaterialFieldState) -> CGFloat {
        guard !state.isShowingError else { return errorLineWidth }
        return lineWidths[state.fieldState] ?? defaultLineWidth
    }

    public func lineColor(for state: MaterialFieldState) -> UIColor {
        guard !state.isShowingError else { return errorColor }
        if state.fieldState == .focused {
            return focusedColor
        }
        return lineColors[state.fieldState] ?? defaultColor
    }

    public func placeholderColor(for state: MaterialFieldState) -> UIColor {
        guard !state.isShowingError else { return errorColor }
        if state.fieldState == .focused {
            return focusedColor
        }
        return placeholderColors[state.fieldState] ?? defaultPlaceholderColor
    }

    public func infoColor(for state: MaterialFieldState) -> UIColor {
        guard !state.isShowingError else { return errorColor }
        return infoColor
    }

    public func backgroundColor(for state: MaterialFieldState) -> UIColor {
        return backgroundColor
    }

    public func borderWidth(for state: MaterialFieldState) -> CGFloat {
        return 0
    }

    public func borderColor(for state: MaterialFieldState) -> UIColor {
        return .clear
    }

    public func left(
        accessory: MaterialUITextField.Accessory,
        for state: MaterialFieldState
    ) -> AccessoryState {
        return accessoryState(accessory, for: state)
    }

    public func right(
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
