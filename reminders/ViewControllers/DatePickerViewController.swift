//
//  DatePickerViewController.swift
//  reminders
//
//  Created by Igor Vedeneev on 02.01.18.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import UIKit

protocol DatePickerDelegate : class {
    func didSelect(date: Date)
}

final class DatePickerViewController : BaseViewController {
    weak var delegate: DatePickerDelegate?
    private lazy var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.33)
        }
        datePicker.frame = CGRect(x: 0, y: view.bounds.height - 216, width: view.bounds.width, height: 216)
        datePicker.backgroundColor = .white
        datePicker.locale = NSLocale.current
        datePicker.sizeToFit()
        view.addSubview(datePicker)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: view.bounds.height - datePicker.bounds.height-44, width: view.bounds.width, height: 44))
        let item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceItem, item], animated: false)
        view.addSubview(toolbar)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = .clear
        }
    }
    
    @objc func doneAction() {
        delegate?.didSelect(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        dismiss(animated: true, completion: nil)
    }
}
