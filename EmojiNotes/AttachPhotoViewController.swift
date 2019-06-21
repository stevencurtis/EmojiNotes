//
//  AttachPhotoViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

class AttachPhotoViewController: UIViewController {
    
    var noteDelegate : CreateNoteDelegate?
    
    lazy var imagePicker : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.addChild(picker)
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(imagePicker)
        view.addSubview(imagePicker.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imagePicker.view.frame = view.bounds
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AttachPhotoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
//        guard let note = note,
//            let context = note.managedObjectContext else {
//                return
//        }
//
//        let attachment = Attachment(context: context)
//        attachment.dateCreated = Date()
//        attachment.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        attachment.note = note
        
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            noteDelegate?.provImage(img)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension AttachPhotoViewController: UINavigationControllerDelegate {
}


