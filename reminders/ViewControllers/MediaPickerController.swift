//
//  MediaPickerController.swift
//  Marketplace
//
//  Created by Igor Vedeneev on 30.11.17.
//  Copyright © 2017 WeAreLT. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol MediaPickerControllerDelegate : class {
    func didPick(image: UIImage)
}

final class MediaPickerController : NSObject {
    weak var delegate: (MediaPickerControllerDelegate & UIViewController)?
    init(delegate: MediaPickerControllerDelegate & UIViewController) {
        self.delegate = delegate
    }
    
    func present() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { [weak self] (action) in
            self?.requestCameraAuthStatusAndPresentPicker()
        }
        
        let galleryAction = UIAlertAction(title: "Галлерея", style: .default) { [weak self] (action) in
            self?.requestPhotosAuthStatusAndPresentPicker()
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        
        presentFromDelegate(viewController: alertController)
    }
}

//MARK:- Permissions
private extension MediaPickerController {
    func requestCameraAuthStatusAndPresentPicker() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authorizationStatus {
        case .authorized:
            presentPicker(type: .camera)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                self?.presentPicker(type: .camera)
            }
            break
        case .denied, .restricted:
            openSettings(for: .camera)
            break
        }
    }
    
    func requestPhotosAuthStatusAndPresentPicker() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .authorized:
            presentPicker(type: .photoLibrary)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ [weak self] (status) in
                guard status == .authorized else { return }
                self?.presentPicker(type: .photoLibrary)
            })
            break
        case .denied, .restricted:
            openSettings(for: .photoLibrary)
            break
        }
    }
}

//MARK:- Presentation
private extension MediaPickerController {
    func openSettings(for mediaType: UIImagePickerControllerSourceType) {
        let mediaTypeDescription = mediaType == .camera ? "Камера" : "Галлерея"
        let alertController = UIAlertController(title: "test", message: "test", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Перейти в настройки", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }))
        alertController.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.presentFromDelegate(viewController: alertController)
        }
    }
    
    func presentPicker(type: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.delegate = self
        DispatchQueue.main.async {
            self.presentFromDelegate(viewController: picker)
        }
    }
    
    func presentFromDelegate(viewController: UIViewController) {
        self.delegate?.present(viewController, animated: true, completion: nil)
    }
}

//MARK:- UIImagePickerControllerDelegate
extension MediaPickerController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer { self.delegate?.dismiss(animated: true, completion: nil) }
        //FIXME: use image url if no image object @ info
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        self.delegate?.didPick(image: chosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.delegate?.dismiss(animated: true, completion: nil)
    }
}

//MARK:- UINavigationControllerDelegate
extension MediaPickerController : UINavigationControllerDelegate {}

