import UIKit

// MARK: - Text Area

extension MaterialUITextField {

    var rectLeftPadding: CGFloat {
        guard !leftAccessoryView.isHidden else { return 0 }
        return leftAccessoryView.bounds.width + innerHorizontalSpacing
    }

    var rectRightPadding: CGFloat {
        guard !rightAccessoryView.isHidden else { return 0 }
        return rightAccessoryView.bounds.width + innerHorizontalSpacing
    }

    private var textInsets: UIEdgeInsets {
        return UIEdgeInsets(
            top: topPadding + insets.top,
            left: rectLeftPadding + insets.left,
            bottom: bottomPadding + insets.bottom,
            right: rectRightPadding + insets.right
        )
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let base = super.textRect(forBounds: bounds)
        return base.inset(by: textInsets)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let base = super.editingRect(forBounds: bounds)
        return base.inset(by: textInsets)
    }

    open override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var base = super.clearButtonRect(forBounds: bounds)
        base = base.offsetBy(dx: -rectRightPadding - insets.right, dy: -base.minY - base.height / 2)
        base = base.offsetBy(dx: 0, dy: backgroundView.bounds.height / 2 + 2)
        return base
    }

    open override func caretRect(for position: UITextPosition) -> CGRect {
        return super.caretRect(for: position).insetBy(dx: 0, dy: fontSize * 0.12)
    }
}
