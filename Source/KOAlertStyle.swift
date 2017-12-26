//
//  KOAlertStyle.swift
//
//  Created by Oleksandr Khymych on 13.12.2017.
//  Copyright © 2017 Oleksandr Khymych. All rights reserved.
//

import Foundation
import UIKit

/// Aler style object
open class KOAlertStyle{
    var backgroundColor     : UIColor!
    var titleColor          : UIColor!
    var titleFont           : UIFont!
    var messageColor        : UIColor!
    var messageFont         : UIFont!
    var cornerRadius        : CGFloat!
    init() {
        self.backgroundColor    = UIColor.white
        self.titleColor         = UIColor.black
        self.titleFont          = UIFont.boldSystemFont(ofSize: 27)
        self.messageFont        = UIFont.systemFont(ofSize: 17)
        self.messageColor       = UIColor.gray
        self.cornerRadius       = 2
    }
}
