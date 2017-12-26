//
//  CustomTextField.swift
//  Example
//
//  Created by Oleksandr Khymych on 26.12.2017.
//  Copyright © 2017 Oleksandr Khymych. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
        override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.green
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.green
        self.textColor = .black
      //  fatalError("init(coder:) has not been implemented")
    }
}
