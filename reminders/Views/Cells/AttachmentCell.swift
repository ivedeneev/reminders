//
//  AttachmentCell.swift
//  reminders
//
//  Created by Igor Vedeneev on 30.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
import CollectionKit

protocol AttachmentViewModelProtocol {
    var iconName: String { get }
    var placeholder: String { get }
    var textValue: String? { get set }
    
    init(iconName: String, placeholder: String)
}

final class ContactAttachmentViewModel : AttachmentViewModelProtocol {
    let iconName : String
    let placeholder : String
    var textValue : String?
    
    init(iconName: String, placeholder: String) {
        self.iconName = iconName
        self.placeholder = placeholder
    }
}

final class PhotoAttachmentViewModel : AttachmentViewModelProtocol {
    let iconName : String
    let placeholder : String
    var textValue : String?
    
    init(iconName: String, placeholder: String) {
        self.iconName = iconName
        self.placeholder = placeholder
    }
}

final class RecordingAttachmentViewModel : AttachmentViewModelProtocol {
    let iconName : String
    let placeholder : String
    var textValue : String?
    
    init(iconName: String, placeholder: String) {
        self.iconName = iconName
        self.placeholder = placeholder
    }
}

final class AttachmentCell : UICollectionViewCell {
    private let iconImageView = UIImageView()
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iconImageView.contentMode = .scaleAspectFit
        textLabel.font = UIFont.systemFont(ofSize: 16)
        
        addSubview(iconImageView)
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = CGSize(width: 20, height: 20)
        let origin = CGPoint(x: 15, y: (bounds.height - size.height) / 2)
        iconImageView.frame = CGRect(origin: origin, size: size)
        
        textLabel.frame = CGRect.init(x: iconImageView.frame.maxX + 10, y: 0, width: bounds.width - (iconImageView.frame.maxX + 10 + 15), height: bounds.height)
    }
}

extension AttachmentCell : ConfigurableCollectionItem {
    static func estimatedSize(item: AttachmentViewModelProtocol?, collectionViewSize: CGSize) -> CGSize {
        return CGSize(width: collectionViewSize.width, height: 40)
    }
    
    func configure(item: AttachmentViewModelProtocol) {
        if let text = item.textValue {
            textLabel.text = text
            textLabel.textColor = Color.text
        } else {
            textLabel.text = item.placeholder
            textLabel.textColor = Color.placeholder
        }
        iconImageView.image = UIImage(named: item.iconName)
    }
}

