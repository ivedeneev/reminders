//
//  DatePickerCell.swift
//  reminders
//
//  Created by Igor Vedeneev on 31.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
import CollectionKit

final class DatePickerCell : UICollectionViewCell {

    private var datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(datePicker)
        datePicker.locale = NSLocale.current
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        datePicker.frame = bounds
    }
}

extension DatePickerCell : ConfigurableCollectionItem {
    func configure(item: ()) {
        
    }
    
    static func estimatedSize(item: Void?, collectionViewSize: CGSize) -> CGSize {
        return CGSize(width: collectionViewSize.width, height: 216)
    }
}
