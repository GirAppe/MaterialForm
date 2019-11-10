//
//  UndeerlyingField.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 02/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

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
