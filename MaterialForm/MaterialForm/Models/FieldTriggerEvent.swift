//
//  FieldControlevent.swift
//  MaterialForm
//
//  Created by Andrzej Michnia on 30/09/2019.
//  Copyright © 2019 MakeAWishFoundation. All rights reserved.
//

import Foundation

@objc public enum FieldTriggerEvent: Int {
    case none
    case tap
    case rightAccessoryTap // rightTap
    case leftAccessoryTap
    case returnTap
    case beginEditing
    case finishedEditing
}
