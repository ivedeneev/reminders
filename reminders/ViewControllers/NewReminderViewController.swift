//
//  NewReminderViewController.swift
//  reminders
//
//  Created by Igor Vedeneev on 29.12.17.
//  Copyright © 2017 Igor Vedeneev. All rights reserved.
//

import UIKit
import CollectionKit

protocol NewReminderViewModelProtocol {
    func scheduleNewReminder()
}

final class DatePickerViewModel : TextInputViewModelProtocol {
    init(placeholder: String, isManualEditingAllowed : Bool = true) {
        self.placeholder = placeholder
        self.isManualEditingAllowed = isManualEditingAllowed
    }
    
    var text: String?
    let placeholder: String?
    var isManualEditingAllowed: Bool
    var date: Date?
}

final class NewReminderViewModel : NewReminderViewModelProtocol {
    let titleViewModel: TextInputViewModel
    let dateViewModel: DatePickerViewModel
//    let titleViewModel: TextInputViewModel
//    let titleViewModel: TextInputViewModel

    
    init() {
        titleViewModel = TextInputViewModel(placeholder: "Название")
        dateViewModel = DatePickerViewModel(placeholder: "Время и дата", isManualEditingAllowed : false)
    }
    
    func scheduleNewReminder() {
        print(titleViewModel.text)
    }
}

protocol NewReminderViewControllerPresenter : class {
    func toggle()
    func handlePan(gestureRecognizer: UIPanGestureRecognizer)
}

final class NewReminderViewController : BaseViewController {
    weak var delegate: NewReminderViewControllerPresenter?
    static let pullUpHeaderHeight: CGFloat = 54
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var director: CollectionDirector = CollectionDirector(colletionView: self.collectionView)
    private let titleView = UIView()
    private var datePickerRow: AbstractCollectionItem!
    
    private let headerTapGestureRecognizer = UITapGestureRecognizer()
    private let pullUpPanGestureRecognizer = UIPanGestureRecognizer()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(delegate: NewReminderViewControllerPresenter) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: NewReminderViewModel = NewReminderViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        let section = CollectionSection()
        section.insetForSection = UIEdgeInsetsMake(0, 0, 20, 0)
        section += CollectionItem<SingleLineTextInputCell>(item: self.viewModel.titleViewModel)
        let datarow = CollectionItem<SingleLineTextInputCell>(item: self.viewModel.dateViewModel)
        datePickerRow = CollectionItem<DatePickerCell>(item: ())
        datarow.onSelect = { [unowned self] _ in
            self.view.endEditing(true)
            self.showDatePicker()
        }
        section += datarow
//        let repeatRate = TextFieldCellViewModel(placeholder: "Повтор")
//        let notes = TextInputViewModel(placeholder: "Заметки")
//        section += CollectionItem<SingleLineTextInputCell>(item: repeatRate)
//        section += CollectionItem<SingleLineTextInputCell>(item: notes)
        director += section
        
        let section1 = CollectionSection()
        section1.headerItem = CollectionItem<AttachmentSectionHeader>(item: "прикрепить")
        let callVm = ContactAttachmentViewModel(iconName: "phone", placeholder: "Номер телефона")
        let photoVm = PhotoAttachmentViewModel(iconName: "photo", placeholder: "Фото из галереи или камеры")
        let micVm = RecordingAttachmentViewModel(iconName: "record", placeholder: "Аудиозапись")
        
        let attachmentsVms: [AttachmentViewModelProtocol] = [callVm, photoVm, micVm]
        section1.append(items: attachmentsVms.map { CollectionItem<AttachmentCell>(item: $0) })
        director += section1

        setupUI()
    }
    
    func setupCollectionView() {
        collectionView.frame = CGRect(x: 0, y: NewReminderViewController.pullUpHeaderHeight, width: view.bounds.width, height: view.bounds.height - NewReminderViewController.pullUpHeaderHeight)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.backgroundColor = Color.background
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        collectionView.register(AttachmentSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: AttachmentSectionHeader.reuseIdentifier)
        
        director.shouldUseAutomaticCellRegistration = true
    }
    
    @objc private func handleHeaderTap() {
       delegate?.toggle()
    }
    
    @objc private func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        delegate?.handlePan(gestureRecognizer: gestureRecognizer)
    }
    
    func setupUI() {
        titleView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 54)
        titleView.autoresizingMask = [.flexibleWidth]
        titleView.backgroundColor = Color.background
        titleView.isUserInteractionEnabled = true
        headerTapGestureRecognizer.addTarget(self, action: #selector(handleHeaderTap))
        pullUpPanGestureRecognizer.addTarget(self, action: #selector(handlePan(gestureRecognizer:)))
        titleView.addGestureRecognizer(headerTapGestureRecognizer)
        titleView.addGestureRecognizer(pullUpPanGestureRecognizer)
        
        view.backgroundColor = .clear
        
        let separatorLayer = CALayer()
        separatorLayer.frame = CGRect(x: 0, y: 54 - 0.5, width: view.bounds.width, height: 0.5)
        separatorLayer.backgroundColor = Color.separator.cgColor
        titleView.layer.addSublayer(separatorLayer)
        
        let buttonFrame = CGRect(x: 15, y: titleView.bounds.midY - 15, width: 30, height: 30)
        let cancelButton = UIButton(frame: buttonFrame)
        cancelButton.addTarget(self, action: #selector(_dismiss), for: .touchUpInside)
        let image = #imageLiteral(resourceName: "Close").withRenderingMode(.alwaysTemplate)
        cancelButton.setImage(image, for: .normal)
        cancelButton.tintColor = Color.activeField
        titleView.addSubview(cancelButton)
        
        let padding: CGFloat = 8
        let label = UILabel(frame: CGRect(x: cancelButton.frame.maxX + 8, y: 15, width: view.bounds.width - padding * 2, height: 24))
        label.textColor = Color.text
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        label.text = "Добавить напоминание"
        label.autoresizingMask = [.flexibleWidth]
        titleView.addSubview(label)
        
        view.addSubview(titleView)
        
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 15
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let shadowLayer = CALayer()
        shadowLayer.frame = titleView.bounds
        
        let shadowPath1 = UIBezierPath(roundedRect: shadowLayer.frame, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15)).cgPath
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = .zero
        shadowLayer.shadowOpacity = 0.33
        shadowLayer.shadowRadius = 6
        shadowLayer.shadowPath = shadowPath1
        
        view.layer.insertSublayer(shadowLayer, below: collectionView.layer)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.bounds.width * 0.8, height: 44))
        button.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
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
    
    @objc func _dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveAction() {
        viewModel.scheduleNewReminder()
    }
    
    private func showDatePicker() {
        let datepicker = DatePickerViewController()
        datepicker.delegate = viewModel
        datepicker.modalPresentationStyle = .overFullScreen
        datepicker.modalTransitionStyle = .crossDissolve
        present(datepicker, animated: true, completion: nil)
    }
}

extension NewReminderViewModel : DatePickerDelegate {
    func didSelect(date: Date) {
        dateViewModel.date = date
    }
}
