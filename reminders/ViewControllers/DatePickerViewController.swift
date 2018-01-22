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
        

        datePicker.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 216)
        datePicker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        datePicker.backgroundColor = .white
        datePicker.locale = NSLocale.current
        view.addSubview(datePicker)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: view.bounds.height - 44, width: view.bounds.width, height: 44))
        let item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceItem, item], animated: false)
        view.addSubview(toolbar)
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.33)
            self.datePicker.frame = CGRect(x: 0, y: self.view.bounds.height - 216, width: self.view.bounds.width, height: 216)
            toolbar.frame = CGRect(x: 0, y: self.view.bounds.height - self.datePicker.bounds.height-44, width: self.view.bounds.width, height: 44)
        }
        

        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = .clear
           self.datePicker.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 216)
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
