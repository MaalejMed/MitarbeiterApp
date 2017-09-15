//
//  PhotoLibraryReaderViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 15/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

class PhotoLibraryReaderViewController: UIViewController {
    
    //MARK:- Properties
    var profileImage: UIImage?
    
    //MARK:- Views lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupimagePickerController()
    }
    
    //MARK:- Service
    func selectedImage() ->  UIImage? {
        return profileImage
    }
    
    //MARK:-
    func setupimagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.view.addSubview(imagePickerController.view)
        self.addChildViewController(imagePickerController)
        imagePickerController.didMove(toParentViewController: self)
    }
}

extension PhotoLibraryReaderViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
