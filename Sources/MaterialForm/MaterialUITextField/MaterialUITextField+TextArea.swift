#if canImport(UIKit)

import UIKit

// MARK: - Text Area

@available(iOS 10, *)
extension MaterialUITextField {

    var rectLeftPadding: CGFloat {
        guard !leftAccessoryView.isHidden else { return 0 }
        return leftAccessoryView.bounds.width + innerHorizontalSpacing
    }

    var rectRightPadding: CGFloat {
        guard !rightAccessoryView.isHidden else { return 0 }
        return rightAccessoryView.bounds.width + innerHorizontalSpacing
    }

    var textInsets: UIEdgeInsets { UIEdgeInsets(
        top: topPadding + insets.top + textInsetsCorrection.top,
        left: rectLeftPadding + insets.left + textInsetsCorrection.left,
        bottom: bottomPadding + insets.bottom + textInsetsCorrection.bottom,
        right: rectRightPadding + insets.right + textInsetsCorrection.right
    )}
}

#endif
