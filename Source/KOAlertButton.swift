//
//  KOAlertButton.swift
//
//  Created by Oleksandr Khymych on 13.12.2017.
//  Copyright © 2017 Oleksandr Khymych. All rights reserved.
//

import Foundation
import UIKit

/// Aler button style
open class KOAlertButton{
    var backgroundColor     : UIColor!
    var titleColor          : UIColor!
    var font                : UIFont!
    var borderColor         : UIColor!
    var borderWidth         : CGFloat!
    var cornerRadius        : CGFloat!
    var title               : String!
    init(_ type:KOTypeButton, title:String) {
        self.title = title.uppercased()
        switch type {
        case .cancel:
            self.backgroundColor = UIColor.white
            self.titleColor      = UIColor.black
            self.font            = UIFont.boldSystemFont(ofSize: 19)
            self.borderColor     = UIColor.black
            self.borderWidth     = 1
            self.cornerRadius    = 2.0
        default:
            self.backgroundColor = UIColor.black
            self.titleColor      = UIColor.white
            self.font            = UIFont.boldSystemFont(ofSize: 19)
            self.borderColor     = UIColor.black
            self.borderWidth     = 0
            self.cornerRadius    = 2.0
        }
    }
}
