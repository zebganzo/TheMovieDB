//
//  UITextField+Extension.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 15.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import UIKit

extension UITextField {
    func setInternalPadding() {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        self.leftViewMode = .always
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        self.rightViewMode = .always
    }
}
