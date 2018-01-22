//
//  LocalNotificationsService.swift
//  notes
//
//  Created by Igor Vedeneev on 07.07.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import Foundation
import UserNotifications

protocol LocalNotificationsService {
    func registerForLocalNotifications()
    func scheduleTestNotification()
    func add(title: String?, time: Date, repeatInterval: Int, note: String?)
//    func scheduleEvent()
}

final class LocalNotificationsServiceImpl : NSObject {
    override init() {
        super.init()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
}

extension LocalNotificationsServiceImpl : LocalNotificationsService {
    func add(title: String?, time: Date, repeatInterval: Int, note: String?) {
        let timerEvent = Event(identifier: "fdfd", date: time, title: title, repeatInterval: repeatInterval, note: note)
        let request = notificationRequest(from: timerEvent)
        schedule(request: request)
    }

    func scheduleTestNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Don't forget"
        content.body = "Buy some milk"
        content.sound = UNNotificationSound.default()
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze",
                                                title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "UYLDeleteAction",
                                                title: "Delete", options: [.destructive])
        
        
        let category = UNNotificationCategory(identifier: "UYLReminderCategory",
                                              actions: [snoozeAction,deleteAction],
                                              intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
        
        content.categoryIdentifier = "UYLReminderCategory"

        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3,
                                                        repeats: false)
        
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        
        
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }

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
    
    //MARK:- Private
    private func notificationRequest(from event: Event) -> UNNotificationRequest {
        var requestBuilder: LocalNotificationRequestBuilder
        requestBuilder = TimerNotificationRequestBuilder()
//        switch event.type {
//        case .timer:
//            requestBuilder = TimerNotificationRequestBuilder()
//            break
//
//        case .reminder:
//            requestBuilder = TimerNotificationRequestBuilder()
//            break
//
//        }
        
        return requestBuilder.request(event: event)
    }
    
    private func schedule(request: UNNotificationRequest) {
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
}


//MARK:- UNUserNotificationCenterDelegate
extension LocalNotificationsServiceImpl : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
