//
//  InsettedLabel.swift
//  reminders
//
//  Created by Igor Vedeneev on 30.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

class InsettedLabel : UILabel {
    var textInset: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInset))
    }
}
