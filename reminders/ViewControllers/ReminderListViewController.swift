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
//        let nc = UINavigationController(navigationBarClass: UINavigationBar.self, toolbarClass: nil)
//        nc.viewControllers = [ NewReminderViewController() ]
//         let nc = UINavigationController.init(rootViewController: NewReminderViewController())
        
//        nc.setNavigationBarHidden(true, animated: false)
//        nc.modalPresentationStyle = .popover
//        nc.modalTransitionStyle = .crossDissolve
//        nc.popoverPresentationController!.delegate = self
        
        let rect = UIScreen.main.bounds
        let safeAreaInsets = UIApplication.shared.keyWindow!.safeAreaInsets
        let inset: CGFloat = 15
        let width = rect.width
        let height = min(rect.height - (safeAreaInsets.top + inset + 20), 600)
        let originY = rect.height - (height)
        let frame = CGRect(x: 0, y: originY, width: width, height: height)
        
        let vc = NewReminderViewController()
        let dimView = UIView(frame: navigationController!.view.bounds)
        dimView.backgroundColor = Color.color(hex: 0x8A8A8F, alpha: 0.45)
        navigationController?.view.addSubview(dimView)
        
        navigationController?.addChildViewController(vc)
        vc.view.frame = frame
        
        let path = UIBezierPath(roundedRect: vc.view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 15, height: 15))

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        vc.view.layer.mask = maskLayer
        
        let shadowLayer = CALayer()
        let shadowSize : CGFloat = 3
        let shadowFrame = CGRect(x: frame.origin.x - shadowSize / 2,
                                 y: frame.origin.y - shadowSize / 2,
                                 width: frame.size.width + shadowSize,
                                 height: frame.size.height + shadowSize)
        let shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 15)
//        self.view.layer.masksToBounds = false
//        shadowLayer.frame = shadowFrame
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = .zero
        shadowLayer.shadowOpacity = 0.33
        shadowLayer.shadowRadius = 6
        shadowLayer.shadowPath = shadowPath.cgPath
        view.layer.addSublayer(shadowLayer)
//        shadowLayer.zPosition = -1
        
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
