//
//  AppDelegateRouter.swift
//  reminders
//
//  Created by Igor Vedeneev on 29.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

protocol AppDelegateRouterProtocol {
    func showInitialScreen()
}

final class AppDelegateRouter : AppDelegateRouterProtocol {
    private unowned var appDelegate: AppDelegate
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    func showInitialScreen() {
        let window = appDelegate.window
        let navController = UINavigationController(rootViewController: ReminderListViewController())
        window!.rootViewController = navController
        window!.makeKeyAndVisible()
    }
}
