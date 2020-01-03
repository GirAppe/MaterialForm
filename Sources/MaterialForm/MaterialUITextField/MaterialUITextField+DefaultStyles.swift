#if canImport(UIKit)

import UIKit

// MARK: - Styles Container

@available(iOS 10, *)
extension MaterialUITextField {

    /// Container for default styles
    public struct Style {
        /// MaterialuitextField style for border type == `.none`
        public static var none: NoneFieldStyle { NoneFieldStyle() }
        /// MaterialuitextField style for border type == `.none`, overriden with custom configuration
        public static func none(_ config: (NoneFieldStyle) -> Void) -> NoneFieldStyle { none.configure(with: config) }
        /// MaterialuitextField style for border type == `.line`
        public static var line: LineFieldStyle { LineFieldStyle() }
        /// MaterialuitextField style for border type == `.line`, overriden with custom configuration
        public static func line(_ config: (LineFieldStyle) -> Void) -> LineFieldStyle { line.configure(with: config) }
        /// MaterialuitextField style for border type == `.bezel`
        public static var bezel: BezelFieldStyle { BezelFieldStyle() }
        /// MaterialuitextField style for border type == `.bezel`, overriden with custom configuration
        public static func bezel(_ config: (BezelFieldStyle) -> Void) -> BezelFieldStyle { bezel.configure(with: config) }
        /// MaterialuitextField style for border type == `.roundedRect`
        public static var rounded: RoundedFieldStyle { RoundedFieldStyle() }
        /// MaterialuitextField style for border type == `.roundedRect`, overriden with custom configuration
        public static func rounded(_ config: (RoundedFieldStyle) -> Void) -> RoundedFieldStyle { rounded.configure(with: config) }
    }
}

// MARK: - None

@available(iOS 10, *)
/// Simple field style. No background, line shown only for `focused` and `filled` states.
public class NoneFieldStyle: DefaultMaterialTextFieldStyle {

    override init() {
        super.init()
        lineWidths[.empty] = 0
        defaultLineWidth = 1
        backgroundColor = .clear
        insets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }

    override public func backgroundColor(for state: MaterialFieldState) -> UIColor {
        .clear
    }
}

// MARK: - Line

@available(iOS 10, *)
/// Old material design field style. No background, with light underline, becoming thicker when `filled` / `focused`.
public class LineFieldStyle: DefaultMaterialTextFieldStyle {

    override init() {
        super.init()
        defaultLineWidth = 1
        backgroundColor = .clear
        insets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }

    override public func backgroundColor(for state: MaterialFieldState) -> UIColor {
        .clear
    }
}

// MARK: - Bezel

@available(iOS 10, *)
/// Bezel style, with no underline and no background, but with rounded border.
public class BezelFieldStyle: DefaultMaterialTextFieldStyle {

    /// Bezel border width.
    public var borderWidth: CGFloat = 1

    override init() {
        super.init()
        defaultLineWidth = 0
        backgroundColor = .clear
    }

    override public func lineWidth(for state: MaterialFieldState) -> CGFloat {
        return 0
    }

    override public func borderColor(for state: MaterialFieldState) -> UIColor {
        return lineColor(for: state)
    }

    override public func borderWidth(for state: MaterialFieldState) -> CGFloat {
        return borderWidth
    }

    override public func backgroundColor(for state: MaterialFieldState) -> UIColor {
        .clear
    }
}

// MARK: - Rounded

@available(iOS 10, *)
/// Default Material Design text field style. Have background with top corners rounded, and underline showing for `filled` / `focused` states.
public class RoundedFieldStyle: DefaultMaterialTextFieldStyle { }

#endif
