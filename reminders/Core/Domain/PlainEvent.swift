//
//  PlainEvent.swift
//  reminders
//
//  Created by Igor Vedeneev on 13.01.18.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import Foundation

struct Event {
    let identifier: String
    let date: Date
    let title: String?
    let repeatInterval: Int
    let note: String?
}

struct Contact {
    let identifier: String
    let phone: String
    let name: String?
}
