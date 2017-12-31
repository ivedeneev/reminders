//
//  Color.swift
//  reminders
//
//  Created by Igor Vedeneev on 29.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

final class Color {
    static let background = color(hex: 0xffffff)
    static let separator = color(hex: 0xC8C7CC)
    static let placeholder = color(hex: 0xC8C7CC)
    static let text = color(hex: 666666)
    static let activeField = color(hex: 0x4A90E2)
    static let sectionTitle = color(hex: 0x8A8A8F)
}

//MARK:- Private
extension Color {
    static func color(hex: Int, alpha: CGFloat = 1) -> UIColor {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        return UIColor(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
}
