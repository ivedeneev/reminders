//
//  LocalNotificationFactory.swift
//  notes
//
//  Created by Igor Vedeneev on 08.07.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation
import UserNotifications

protocol LocalNotificationRequestBuilder {
    func identifier(event: Event) -> String
    func content(event: Event) -> UNMutableNotificationContent
    func trigger(event: Event) -> UNNotificationTrigger
    func request(event: Event) -> UNNotificationRequest
}

extension LocalNotificationRequestBuilder {
    func request(event: Event) -> UNNotificationRequest {
        let content = self.content(event: event)
        let trigger = self.trigger(event: event)
        let identifier = self.identifier(event: event)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        return request
    }
}

final class TimerNotificationRequestBuilder : LocalNotificationRequestBuilder {
    func identifier(event: Event) -> String {
        return "com.igorv.notifire.timer"
    }
    
    func content(event: Event) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = event.title ?? ""
        content.body = event.note ?? ""
        content.sound = UNNotificationSound.default()
        
        let stopAction = UNNotificationAction(identifier: "Stop",
                                                title: "Остановить", options: [])
        
        
        let categoryId = "StopTimerNotificationCategory"
        let category = UNNotificationCategory(identifier: categoryId,
                                              actions: [stopAction],
                                              intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        content.categoryIdentifier = categoryId
        
        return content
    }
    
    func trigger(event: Event) -> UNNotificationTrigger {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: event.date.timeIntervalSinceNow,
                                                        repeats: false)
        
        return trigger
    }
}




