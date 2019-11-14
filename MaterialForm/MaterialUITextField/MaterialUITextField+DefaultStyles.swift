import UIKit

// MARK: - Styles Container

public extension MaterialUITextField {

    struct Style {
        static let none: MaterialTextFieldStyle = NoneFieldStyle()
        static let line: MaterialTextFieldStyle = LineFieldStyle()
        static let bezel: MaterialTextFieldStyle = BezelFieldStyle()
        static let rounded: MaterialTextFieldStyle = RoundedFieldStyle()
    }
}

// MARK: - None

private class NoneFieldStyle: DefaultMaterialTextFieldStyle {

    override init() {
        super.init()
        lineWidths[.empty] = 0
        defaultWidth = 1
        backgroundColor = .clear
        insets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - Line

private class LineFieldStyle: DefaultMaterialTextFieldStyle {

    override init() {
        super.init()
        defaultWidth = 1
        backgroundColor = .clear
        insets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - Bezel

private class BezelFieldStyle: DefaultMaterialTextFieldStyle {

    var borderWidth: CGFloat = 1

    override init() {
        super.init()
        defaultWidth = 0
        backgroundColor = .clear
    }

    override func lineWidth(for state: MaterialFieldState) -> CGFloat {
        return 0
    }

    override func borderColor(for state: MaterialFieldState) -> UIColor {
        return lineColor(for: state)
    }

    override func borderWidth(for state: MaterialFieldState) -> CGFloat {
        return borderWidth
    }
}

// MARK: - Rounded

private class RoundedFieldStyle: DefaultMaterialTextFieldStyle { }
