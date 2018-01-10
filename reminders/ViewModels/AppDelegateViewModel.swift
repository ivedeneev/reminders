//
//  AppDelegateViewModel.swift
//  reminders
//
//  Created by Igor Vedeneev on 29.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation
import UserNotifications

final class AppDelegateViewModel {
    func registerForLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
}
