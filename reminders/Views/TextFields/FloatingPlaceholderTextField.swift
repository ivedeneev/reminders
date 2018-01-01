//
//  flfl.swift
//  FLT
//
//  Created by Igor Vedeneev on 27.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit

class FloatingLabelTextField : UITextField {
    var inactiveColor: UIColor = UIColor.lightGray {
        didSet {
            placeholderLabel.textColor = inactiveColor
        }
    }
    var placeholderFont: UIFont! {
        didSet {
            placeholderLabel.font = placeholderFont
        }
    }
    
    private var placeholderLabel = UILabel()
    private var flotatingLabelTopPosition: CGFloat {
        return 12
    }
    
    override var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
            attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSAttributedStringKey.foregroundColor : Color.sectionTitle, NSAttributedStringKey.font : self.font!])
        }
    }
    
    override var attributedPlaceholder: NSAttributedString? {
        didSet {
            placeholderLabel.text = attributedPlaceholder?.string.uppercased()
            placeholderLabel.sizeToFit()
//            attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSAttributedStringKey.foregroundColor : inactiveColor, NSAttributedStringKey.font : self.font!])
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let textSize = super.textRect(forBounds: bounds).size
        return CGRect.init(origin: CGPoint.init(x: 0, y: 13), size: textSize)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let textSize = super.textRect(forBounds: bounds).size
        return CGRect.init(origin: CGPoint.init(x: 0, y: 13), size: textSize)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let textSize = super.textRect(forBounds: bounds).size
        return CGRect.init(origin: CGPoint.init(x: 0, y: 13), size: textSize)
    }
    
    private func initialSetup() {
        setupPlaceholderLabel()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kg_didBeginEditing(_:)),
                                               name: .UITextFieldTextDidBeginEditing,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kg_textDidEndEditing(_:)),
                                               name: .UITextFieldTextDidEndEditing,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kg_textDidChange(_:)),
                                               name: .UITextFieldTextDidChange,
                                               object: nil)
    }
    
    private func setupPlaceholderLabel() {
//        placeholderLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
        placeholderLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular)
    }
    
    private func animatePlaceholderLabelOnTop() {
        self.placeholderLabel.frame.origin = self.placeholderRect(forBounds: self.bounds).origin
        UIView.animate(withDuration: 0.2) {
            self.placeholderLabel.alpha = 1
            self.placeholderLabel.frame.origin = CGPoint(x: 0, y: self.flotatingLabelTopPosition)
            self.placeholderLabel.textColor = self.tintColor
        }
    }
    
    private func animatePlaceholderLabelOnBottom() {
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.placeholderLabel.textColor = self.inactiveColor
                        self.placeholderLabel.frame.origin = self.placeholderRect(forBounds: self.bounds).origin
                        self.placeholderLabel.alpha = 0
        }) { (_) in
            self.placeholderLabel.removeFromSuperview()
        }
    }
    
    @objc private func kg_textDidChange(_ notification: Notification) {
        guard let tf = notification.object as? UITextField, tf == self else { return }
        
        if placeholderLabel.superview == nil {
            addSubview(placeholderLabel)
        }
        
        if let txt = text, !txt.isEmpty {
            if self.placeholderLabel.frame.origin.y != self.flotatingLabelTopPosition {
                animatePlaceholderLabelOnTop()
            }
        } else {
            animatePlaceholderLabelOnBottom()
        }
    }
    
    @objc private func kg_didBeginEditing(_ notification: Notification) {
        guard let tf = notification.object as? UITextField, tf == self else { return }
        self.placeholderLabel.textColor = self.tintColor
    }
    
    @objc private func kg_textDidEndEditing(_ notification: Notification) {
        guard let tf = notification.object as? UITextField, tf == self else { return }
        self.placeholderLabel.textColor = self.inactiveColor
    }
    
    override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
}

