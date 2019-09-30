//
//  UnderlyingLineView.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 30/09/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

final internal class UnderlyingLineView: UIStackView {

    private var mainLine = UIView()
    private var accessoryLine = UIView()
    private var heightContraint: NSLayoutConstraint!

    var height: CGFloat = 1 { didSet { update() } }
    var color: UIColor = .darkText { didSet { update() } }
    var underAccessory: Bool = true { didSet { update() } }

    func update() {
        heightContraint?.constant = height
        mainLine.backgroundColor = color
        accessoryLine.backgroundColor = underAccessory ? color : .clear
    }

    func buildAsUnderline(for field: UIView) {
        axis = .horizontal
        alignment = .fill
        heightContraint = heightAnchor.constraint(equalToConstant: height)
        heightContraint.isActive = true

        mainLine.removeFromSuperview()
        accessoryLine.removeFromSuperview()
        mainLine = UIView()
        accessoryLine = UIView()

        addArrangedSubview(mainLine)
        addArrangedSubview(accessoryLine)

        mainLine.widthAnchor.constraint(equalTo: field.widthAnchor).isActive = true
        update()
    }
}
