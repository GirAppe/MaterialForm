//
//  MaterialTextFieldStyle.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 30/09/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

public protocol MaterialTextFieldStyle: class {

    var maxLineWidth: CGFloat { get }
    var cornerRadius: CGFloat { get set }

    func lineWidth(for state: MaterialFieldState) -> CGFloat
    func lineColor(for state: MaterialFieldState) -> UIColor

    func placeholderColor(for state: MaterialFieldState) -> UIColor
    func textColor(for state: MaterialFieldState) -> UIColor
    func infoColor(for state: MaterialFieldState) -> UIColor

    func backgroundColor(for state: MaterialFieldState) -> UIColor

    func borderWidth(for state: MaterialFieldState) -> CGFloat
    func borderColor(for state: MaterialFieldState) -> UIColor
}
