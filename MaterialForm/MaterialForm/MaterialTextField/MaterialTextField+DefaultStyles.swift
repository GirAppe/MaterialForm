//
//  MaterialTextField+DefaultStyles.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 04/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

public extension MaterialTextField {

    struct Style {
        static let none: MaterialTextFieldStyle = NoneFieldStyle()
        static let line: MaterialTextFieldStyle = LineFieldStyle()
        static let bezel: MaterialTextFieldStyle = BezelFieldStyle()
        static let rounded: MaterialTextFieldStyle = RoundedFieldStyle()
    }
}

private class NoneFieldStyle: DefaultMaterialTextFieldStyle {

    override init() {
        super.init()
        defaultWidth = 1
        backgroundColor = .clear
    }
}

private class LineFieldStyle: DefaultMaterialTextFieldStyle {

    override init() {
        super.init()
        defaultWidth = 1
        backgroundColor = .clear
    }
}

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

private class RoundedFieldStyle: DefaultMaterialTextFieldStyle { }

