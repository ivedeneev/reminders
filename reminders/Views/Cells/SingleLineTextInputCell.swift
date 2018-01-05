//
//  SingleLineTextInputCell.swift
//  reminders
//
//  Created by Igor Vedeneev on 30.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
import CollectionKit

protocol TextInputViewModelProtocol {
    var text: String? {get set}
    var placeholder: String? {get}
    var isManualEditingAllowed: Bool {get set}
    
    init(placeholder: String, isManualEditingAllowed: Bool)
}

final class TextInputViewModel : TextInputViewModelProtocol {
    init(placeholder: String, isManualEditingAllowed : Bool = true) {
        self.placeholder = placeholder
        self.isManualEditingAllowed = isManualEditingAllowed
    }
    
    var text: String?
    let placeholder: String?
    var isManualEditingAllowed: Bool
}

final class SingleLineTextInputCell : UICollectionViewCell {
    private let textField = FloatingLabelTextField()
    var viewModel: TextInputViewModelProtocol!
    private let separatorLayer = CALayer()

    override var isSelected: Bool {
        didSet {
            guard viewModel.isManualEditingAllowed else { return }
            separatorLayer.backgroundColor = isSelected ? Color.activeField.cgColor : Color.placeholder.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.borderStyle = .none
        textField.font = Font.textInput
        textField.placeholderFont = Font.smallTitle
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
        textField.frame = CGRect(x: 15, y: 0, width: bounds.width - 30, height: bounds.height)
    }
}

extension SingleLineTextInputCell : ConfigurableCollectionItem {
    static func estimatedSize(item: TextInputViewModelProtocol?, collectionViewSize: CGSize) -> CGSize {
        print(collectionViewSize.width)
        return CGSize(width: collectionViewSize.width, height: 54)
    }
    
    func configure(item: TextInputViewModelProtocol) {
        self.viewModel = item
        let placeholder = NSAttributedString(string: item.placeholder!, attributes: [NSAttributedStringKey.font: textField.font, NSAttributedStringKey.foregroundColor: Color.placeholder])
        textField.attributedPlaceholder = placeholder
        
        textField.isUserInteractionEnabled = item.isManualEditingAllowed
    }
}

extension SingleLineTextInputCell : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isSelected = true
//        separatorLayer.backgroundColor = Color.activeField.cgColor
//        self.viewModel.willBeginEditing?(!viewModel.isManualEditingAllowed)
        return self.viewModel.isManualEditingAllowed
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        isSelected = false
//        separatorLayer.backgroundColor = Color.placeholder.cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let resultString = (textField.text as? NSString)?.replacingCharacters(in: range, with: string)
        viewModel.text = resultString
        return true
    }
}
