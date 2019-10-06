//
//  FieldState.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 30/09/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import Foundation

@objc public enum FieldControlState: Int, CaseIterable {
    case empty
    case focused
    case filled

    public var description: String {
        switch self {
        case .empty: return "empty"
        case .focused: return "focused"
        case .filled: return "filled"
        }
    }
}
