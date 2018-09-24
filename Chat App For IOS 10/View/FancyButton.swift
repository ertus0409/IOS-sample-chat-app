//
//  FancyButton.swift
//  Chat App For IOS 10
//
//  Created by Guner Babursah on 21/09/2018.
//  Copyright © 2018 Arthur Developments. All rights reserved.
//

import UIKit

class FancyButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5.0
    }

}
