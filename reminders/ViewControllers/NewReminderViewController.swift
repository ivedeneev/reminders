//
//  NewReminderViewController.swift
//  reminders
//
//  Created by Igor Vedeneev on 29.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
import CollectionKit

final class NewReminderViewController : BaseViewController {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var director: CollectionDirector = CollectionDirector(colletionView: self.collectionView)
    private let titleView = UIView()
    private var datePickerRow: AbstractCollectionItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        collectionView.frame = view.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = Color.background
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.contentInset = UIEdgeInsetsMake(54, 0, 50, 0)
        collectionView.register(AttachmentSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: AttachmentSectionHeader.reuseIdentifier)

        director.shouldUseAutomaticCellRegistration = true
        let section = CollectionSection()
        section.insetForSection = UIEdgeInsetsMake(0, 0, 20, 0)
        let ttl = TextFieldCellViewModel(placeholder: "Название")
        let data = TextFieldCellViewModel(placeholder: "Время и дата", isUserInteractionEnabled: false) { [unowned self] (_) in
//            DispatchQueue.main.async {
//                self.director.performUpdates {
//                    if section.contains(item: self.datePickerRow) {
//                        section.remove(item: self.datePickerRow)
//                    } else {
//                        section.insert(item: self.datePickerRow, at: 2)
//                    }
//                }
//            }
        }
        let repeatRate = TextFieldCellViewModel(placeholder: "Повтор")
        let notes = TextFieldCellViewModel(placeholder: "Заметки")
        section += CollectionItem<SingleLineTextInputCell>(item: ttl)
        let datarow = CollectionItem<SingleLineTextInputCell>(item: data)
        
        datePickerRow = CollectionItem<DatePickerCell>(item: ())
        
//        datarow.onSelect = { [unowned self] _ in
//            self.director.performUpdates {
//                if section.contains(item: self.datePickerRow) {
//                    section.remove(item: self.datePickerRow)
//                } else {
//                    section.insert(item: self.datePickerRow, at: 2)
//                }
//            }
//        }
        section += datarow
        
        section += CollectionItem<SingleLineTextInputCell>(item: repeatRate)
        section += CollectionItem<SingleLineTextInputCell>(item: notes)
        director += section
        
        let section1 = CollectionSection()
        section1.headerItem = CollectionItem<AttachmentSectionHeader>(item: "прикрепить")
        let callVm = ContactAttachmentViewModel(iconName: "phone", placeholder: "Номер телефона")
        let photoVm = PhotoAttachmentViewModel(iconName: "photo", placeholder: "Фото из галереи или камеры")
        let micVm = RecordingAttachmentViewModel(iconName: "record", placeholder: "Аудиозапись")
        
        let attachmentsVms: [AttachmentViewModelProtocol] = [callVm, photoVm, micVm]
        section1.append(items: attachmentsVms.map { CollectionItem<AttachmentCell>(item: $0) })
        director += section1
        
//        collectionView.layer.cornerRadius = 15
//        collectionView.clipsToBounds = true
//        view.layer.cornerRadius = 15
//        view.clipsToBounds = true
//
        titleView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 54)
        titleView.autoresizingMask = [.flexibleWidth]
        titleView.backgroundColor = Color.background
    
        let separatorLayer = CALayer()
        separatorLayer.frame = CGRect(x: 0, y: 54 - 0.5, width: view.bounds.width, height: 0.5)
        separatorLayer.backgroundColor = Color.separator.cgColor
        titleView.layer.addSublayer(separatorLayer)
        
        let buttonFrame = CGRect(x: 15, y: titleView.bounds.midY - 15, width: 30, height: 30)
        let cancelButton = UIButton(frame: buttonFrame)
        let image = #imageLiteral(resourceName: "Close").withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(image, for: .normal)
        cancelButton.tintColor = Color.activeField
        titleView.addSubview(cancelButton)
        
        let padding: CGFloat = 8
        let label = UILabel(frame: CGRect(x: cancelButton.frame.maxX + 8, y: 15, width: view.bounds.width - padding * 2, height: 24))
        label.textColor = Color.text
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.text = "Новое напоминание"
        label.autoresizingMask = [.flexibleWidth]
        titleView.addSubview(label)
        
        view.addSubview(titleView)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width * 0.8, height: 44))
        button.addTarget(self, action: #selector(_dismiss), for: .touchUpInside)
        button.backgroundColor = Color.activeField
        button.setTitle("Добавить".uppercased(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin,. flexibleWidth]
        
        let safeAreaInsets = UIApplication.shared.keyWindow!.safeAreaInsets
        button.frame.origin.x = view.bounds.midX - view.bounds.width * 0.4
        button.frame.origin.y = view.bounds.maxY - 60 - safeAreaInsets.bottom
        button.layer.cornerRadius = button.bounds.height / 2
        button.clipsToBounds = true
        view.addSubview(button)
        
        let shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: button.bounds.height / 2)
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowOpacity = 0.33
        button.layer.shadowRadius = 2
        button.layer.shadowPath = shadowPath.cgPath
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(_dismiss))
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Color.background
    }
    
    @objc func _dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let path = UIBezierPath(roundedRect: titleView.frame,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        titleView.layer.mask = maskLayer
        
        
//        let path1 = UIBezierPath(roundedRect: view.bounds,
//                                byRoundingCorners: [.topLeft, .topRight],
//                                cornerRadii: CGSize(width: 15, height: 15))
//
//        let mask = CAShapeLayer()
//        maskLayer.path = path1.cgPath
//        view.layer.mask = mask


//        let shadowLayer = CALayer()
//        let shadowSize : CGFloat = 3
//        let shadowFrame = CGRect(x: -shadowSize / 2,
//                                 y: -shadowSize / 2,
//                                 width: self.view.frame.size.width + shadowSize,
//                                 height: self.view.frame.size.height + shadowSize)
//        let shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 15)
////        self.view.layer.masksToBounds = false
//        shadowLayer.frame = shadowFrame
//        shadowLayer.shadowColor = UIColor.black.cgColor
//        shadowLayer.shadowOffset = .zero
//        shadowLayer.shadowOpacity = 0.33
//        shadowLayer.shadowRadius = 6
//        shadowLayer.shadowPath = shadowPath.cgPath
//        view.layer.addSublayer(shadowLayer)
//        shadowLayer.zPosition = -1
    }
}
