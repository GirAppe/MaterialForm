#if os(iOS) || os(tvOS)

import UIKit

// MARK: - UnderlyingField

@available(iOS 10, *)
final internal class UnderlyingField: UITextField {

    var updateIntrinsicContentSize: Bool = false
    var minimumHeight: CGFloat = 50

    override var intrinsicContentSize: CGSize {
        guard updateIntrinsicContentSize else { return super.intrinsicContentSize }
        return super.intrinsicContentSize.constrainedTo(minHeight: minimumHeight)
    }
}

#endif
