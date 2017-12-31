//
//  ReminderListViewController.swift
//  reminders
//
//  Created by Igor Vedeneev on 29.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

final class ReminderListViewController : BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Напомнинаня"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewReminder))
    }
    
    @objc func showNewReminder() {
        let nc = UINavigationController(navigationBarClass: UINavigationBar.self, toolbarClass: nil)
        nc.viewControllers = [ NewReminderViewController() ]
//         let nc = UINavigationController.init(rootViewController: NewReminderViewController())
        
//        nc.setNavigationBarHidden(true, animated: false)
//        nc.modalPresentationStyle = .popover
//        nc.modalTransitionStyle = .crossDissolve
//        nc.popoverPresentationController!.delegate = self
        
        let rect = UIScreen.main.bounds
        let safeAreaInsets = UIApplication.shared.keyWindow!.safeAreaInsets
        let inset: CGFloat = 15
        let width = min(rect.width - inset * 2, 525)
        let frame = CGRect(x: inset, y: safeAreaInsets.top + inset + 20, width: width, height: rect.height - (safeAreaInsets.top + safeAreaInsets.bottom + inset * 2 + 20))
        
        let vc = NewReminderViewController()
        let dimView = UIView(frame: navigationController!.view.bounds)
        dimView.backgroundColor = Color.color(hex: 0x8A8A8F, alpha: 0.45)
        navigationController?.view.addSubview(dimView)
        
        navigationController?.addChildViewController(vc)
        vc.view.frame = frame
        UIView.transition(with: navigationController!.view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.navigationController?.view.addSubview(vc.view)
        }) { (_) in
            self.navigationController?.didMove(toParentViewController: self)
        }
//        navigationController?.view.addSubview(vc.view)
//        navigationController?.didMove(toParentViewController: self)
        
//        vc.preferredContentSize = frame.size
        
        
//        nc.popoverPresentationController?.sourceView = view
//        nc.popoverPresentationController?.sourceRect = frame
//        nc.popoverPresentationController?.canOverlapSourceViewRect = true
//        nc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
//
//        nc.preferredContentSize = frame.size
        
//        present(nc, animated: true, completion: nil)

    }
}

extension ReminderListViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
