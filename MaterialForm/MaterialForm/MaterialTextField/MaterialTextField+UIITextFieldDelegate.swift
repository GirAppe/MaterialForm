//
//  MaterialTextField+UIITextFieldDelegate.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 02/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

// MARK: - UITextFieldDelegate

extension MaterialTextField: UITextFieldDelegate {

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard proxyDelegate?.textFieldShouldBeginEditing?(self) != false else {
            return false
        }
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        defer { fieldState = .focused }
        proxyDelegate?.textFieldDidBeginEditing?(self)
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        defer { fieldState = text.isEmptyOrNil ? .empty : .filled }
        resignFirstResponder()
        self.layoutSubviews()
        proxyDelegate?.textFieldDidEndEditing?(self)
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        return true
    }

    @available(iOS 13.0, *)
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        proxyDelegate?.textFieldDidChangeSelection?(self)
    }

}
