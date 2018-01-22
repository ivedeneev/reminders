//
//  ContactsPickerViewModel.swift
//  reminders
//
//  Created by Igor Vedeneev on 22.01.18.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import Foundation
import Contacts

//final class ContactsPickerViewModel {
//    var contactStore = CNContactStore()
//
//    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
//        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
//
//        switch authorizationStatus {
//        case .authorized:
//            completionHandler(true)
//
//        case .denied, .notDetermined:
//            self.contactStore.requestAccess(for: .contacts, completionHandler: { (access, accessError) -> Void in
//                if access {
//                    completionHandler(access)
//                }
//                else {
//                    if authorizationStatus == .denied {
////                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
////                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
//////                            self.showMessage(message)
////                        })
////                    }
//                }
//            })
//
//        default:
//            completionHandler(false)
//        }
//        case .restricted:
//            <#code#>
//        }
//}

