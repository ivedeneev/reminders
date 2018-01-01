//
//  AttachmentSectionHeader.swift
//  reminders
//
//  Created by Igor Vedeneev on 30.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
import CollectionKit

final class AttachmentSectionHeader : UICollectionReusableView {
    private let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        textLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
        textLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular)
        textLabel.textColor = Color.sectionTitle
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel.frame = CGRect(x: 15, y: 0, width: bounds.width - 30, height: bounds.height)
    }
}

extension AttachmentSectionHeader : ConfigurableCollectionItem {
    static func estimatedSize(item: String?, collectionViewSize: CGSize) -> CGSize {
        return CGSize.init(width: collectionViewSize.width, height: 20)
    }
    
    func configure(item: String) {
        textLabel.text = item.uppercased()
    }
}
