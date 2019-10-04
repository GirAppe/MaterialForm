//
//  Animatable.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 04/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

protocol Animatable {}

extension UIView: Animatable {}

extension Animatable where Self: UIView {

    func animateStateChange(
        animate: Bool,
        duration: TimeInterval = 0.3,
        _ change: @escaping (Self) -> Void
    )  {
        let animation = {
            change(self)
        }

        guard animate else { return animation() }

        UIView.animate(withDuration: duration, animations: animation)
    }
}
