import UIKit

// MARK: - UnderlyingField

final internal class UnderlyingField: UITextField {

    var updateIntrinsicContentSize: Bool = false
    var minimumHeight: CGFloat = 50

    override var intrinsicContentSize: CGSize {
        guard updateIntrinsicContentSize else { return super.intrinsicContentSize }
        return super.intrinsicContentSize.constrainedTo(minHeight: minimumHeight)
    }
}
