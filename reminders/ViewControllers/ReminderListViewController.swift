//
//  ReminderListViewController.swift
//  reminders
//
//  Created by Igor Vedeneev on 29.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

final class ReminderListViewController : BaseViewController {
    private lazy var newReminderViewController = NewReminderViewController(delegate: self)
    
    private var pullUpAnimator: UIViewPropertyAnimator!
    private var pullDownAnimator: UIViewPropertyAnimator!
    private let dimView = UIView()
    private var isNewReminderViewExpanded: Bool {
        return newReminderViewController.view.superview != nil &&
            newReminderViewController.view.frame.minY < view.bounds.height - NewReminderViewController.pullUpHeaderHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Напомнинаня"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewReminder))
        let tapGr = UITapGestureRecognizer.init(target: self, action: #selector(test))
        dimView.addGestureRecognizer(tapGr)
        dimView.frame = navigationController!.view.bounds
        dimView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dimView.backgroundColor = Color.color(hex: 0x000000, alpha: 0.55)

        let rect = UIScreen.main.bounds
        let safeAreaInsets = UIApplication.shared.keyWindow!.safeAreaInsets
        let topInset: CGFloat = 35
        let width = rect.width
        let height = min(rect.height - (safeAreaInsets.top + topInset + 20), 550)
        let startFrame = CGRect(x: 0, y: UIScreen.main.bounds.height - NewReminderViewController.pullUpHeaderHeight, width: width, height: height)
        newReminderViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin]

        newReminderViewController.view.frame = startFrame
        navigationController?.view.addSubview(newReminderViewController.view)
    }
    
    @objc func test() {
        pullUpAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            let rect = UIScreen.main.bounds
            let safeAreaInsets = UIApplication.shared.keyWindow!.safeAreaInsets
            let topInset: CGFloat = 35
            let width = rect.width
            let height = min(rect.height - (safeAreaInsets.top + topInset + 20), 550)
            let startFrame = CGRect(x: 0, y: UIScreen.main.bounds.height - NewReminderViewController.pullUpHeaderHeight, width: width, height: height)
            self.newReminderViewController.view.frame = startFrame
            self.dimView.alpha = 0
        }
        pullUpAnimator.startAnimation()

    }
    
    @objc func showNewReminder() {
        let rect = UIScreen.main.bounds
        let safeAreaInsets = UIApplication.shared.keyWindow!.safeAreaInsets
        let topInset: CGFloat = 35
        let width = rect.width
        let height = min(rect.height - (safeAreaInsets.top + topInset + 20), 550)
        let startFrame = CGRect(x: 0, y: UIScreen.main.bounds.height - NewReminderViewController.pullUpHeaderHeight, width: width, height: height)
        newReminderViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin]
        newReminderViewController.view.frame = startFrame

        navigationController?.view.insertSubview(dimView, belowSubview: newReminderViewController.view)
        dimView.alpha = 0
        pullUpAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            let originY = self.view.bounds.height - self.newReminderViewController.view.bounds.size.height
            self.newReminderViewController.view.frame.origin.y = originY
            self.dimView.alpha = 1
        }
        
        pullUpAnimator.startAnimation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        //resize & recalculate frame for shadow view & pull up
    }
}

extension ReminderListViewController : NewReminderViewControllerPresenter {
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            if isNewReminderViewExpanded {
                pullUpAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                    let originY = self.view.bounds.height - NewReminderViewController.pullUpHeaderHeight
                    self.newReminderViewController.view.frame.origin.y = originY
                    self.dimView.alpha = 0
                }
            } else {
                dimView.alpha = 0
                navigationController?.view.insertSubview(dimView, belowSubview: newReminderViewController.view)
                pullUpAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
                    let originY = self.view.bounds.height - self.newReminderViewController.view.bounds.size.height
                    self.newReminderViewController.view.frame.origin.y = originY
                    self.dimView.alpha = 1
                }
            }

            pullUpAnimator.pauseAnimation()
            break
        case .changed:
            let progress = gestureRecognizer.translation(in: newReminderViewController.view).y / newReminderViewController.view.bounds.size.height
            pullUpAnimator.fractionComplete = abs(progress)
            break
        case .ended:
            let progress = gestureRecognizer.translation(in: newReminderViewController.view).y / newReminderViewController.view.bounds.size.height
            pullUpAnimator.isReversed = abs(progress) < 0.3
            pullUpAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            break
        default:
            break
        }
    }
    
    func toggle() {
        guard !isNewReminderViewExpanded else { return }
        showNewReminder()
    }
}

extension ReminderListViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
