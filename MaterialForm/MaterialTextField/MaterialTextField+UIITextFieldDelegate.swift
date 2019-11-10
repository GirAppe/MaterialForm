//
//  MaterialUITextField+UIITextFieldDelegate.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 02/10/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import UIKit

// MARK: - UITextFieldDelegate

extension MaterialUITextField: UITextFieldDelegate {

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        defer {
            event = .tap
        }
        return proxyDelegate?.textFieldShouldBeginEditing?(self) ?? isEditingEnabled
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        defer {
            event = .beginEditing
            fieldState = .focused
        }
        proxyDelegate?.textFieldDidBeginEditing?(self)
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return proxyDelegate?.textFieldShouldEndEditing?(self) ?? true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        defer {
            event = .endEditing
            fieldState = text.isEmptyOrNil ? .empty : .filled
        }
        proxyDelegate?.textFieldDidEndEditing?(self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        defer {
            event = .endEditing
            fieldState = text.isEmptyOrNil ? .empty : .filled
        }
        proxyDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        let delegateValue = proxyDelegate?.textField?(
            self,
            shouldChangeCharactersIn: range,
            replacementString: string
        )

        guard delegateValue == nil else { return delegateValue! }
        guard maxCharactersCount > 0 else { return true }

        let oldText = text ?? ""
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)

        return newText.count <= maxCharactersCount || newText.count < oldText.count
    }

    @available(iOS 13.0, *)
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        proxyDelegate?.textFieldDidChangeSelection?(self)
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return (proxyDelegate?.textFieldShouldClear?(self) ?? true) && {
            event = .clear
            return true
        }()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return (proxyDelegate?.textFieldShouldReturn?(self) ?? true) && {
            resignFirstResponder()
            event = .endEditing
            nextField?.becomeFirstResponder()
            return true
        }()
    }
}
