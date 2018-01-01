//
//  SingleLineTextInputCell.swift
//  reminders
//
//  Created by Igor Vedeneev on 30.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
import CollectionKit

final class TextFieldCellViewModel {
    init(placeholder: String, isUserInteractionEnabled : Bool = true, willBeginEditing: ((_ editingIsDenied: Bool) -> Void)? = nil) {
        self.placeholder = placeholder
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.willBeginEditing = willBeginEditing
    }
    
    var text: String?
    let placeholder: String?
    var isUserInteractionEnabled: Bool
    var willBeginEditing: ((_ editingIsDenied: Bool) -> Void)?
}

final class SingleLineTextInputCell : UICollectionViewCell {
    private let textField = FloatingLabelTextField()
    var viewModel: TextFieldCellViewModel!
    private let separatorLayer = CALayer()
    
    override var isHighlighted: Bool {
        didSet {
            separatorLayer.backgroundColor = isHighlighted ? Color.activeField.cgColor : Color.placeholder.cgColor
            guard isHighlighted else { return }
            _ = textField.becomeFirstResponder()
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.borderStyle = .none
//        textField.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        textField.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        textField.textColor = Color.text
        textField.delegate = self
        textField.tintColor = Color.activeField
        textField.inactiveColor = Color.sectionTitle
        backgroundColor = Color.background
        
        separatorLayer.backgroundColor = Color.placeholder.cgColor
        layer.addSublayer(separatorLayer)
        addSubview(textField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        separatorLayer.frame = CGRect(x: 15, y: bounds.height - 0.5, width: bounds.width - 30, height: 0.5)
        let height: CGFloat = 22
//        textField.frame = CGRect(x: 15, y: bounds.height - 4 - height, width: bounds.width - 30, height: height)
        textField.frame = CGRect(x: 15, y: 0, width: bounds.width - 30, height: bounds.height)
    }
}

extension SingleLineTextInputCell : ConfigurableCollectionItem {
    static func estimatedSize(item: TextFieldCellViewModel?, collectionViewSize: CGSize) -> CGSize {
        print(collectionViewSize.width)
        return CGSize(width: collectionViewSize.width, height: 54)
    }
    
    func configure(item: TextFieldCellViewModel) {
        self.viewModel = item
        let placeholder = NSAttributedString(string: item.placeholder!, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: Color.placeholder])
        textField.attributedPlaceholder = placeholder
    }
}

extension SingleLineTextInputCell : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        separatorLayer.backgroundColor = Color.activeField.cgColor
        self.viewModel.willBeginEditing?(!viewModel.isUserInteractionEnabled)
        return viewModel.isUserInteractionEnabled
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        separatorLayer.backgroundColor = Color.placeholder.cgColor
    }
}
