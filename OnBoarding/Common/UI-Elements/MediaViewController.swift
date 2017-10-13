//
//  MediaViewController.swift
//  OnBoarding
//
//  Created by mmaalej on 15/09/2017.
//  Copyright © 2017 mmaalej. All rights reserved.
//

import UIKit

protocol MediaViewControllerDelegate: class {
    func didSelectProfileImage(mediaViewController:MediaViewController, image: UIImage?)
}
class MediaViewController: UIViewController {
    
    //MARK:- Properties
    private var selectedImage: UIImage?
    var delegate:MediaViewControllerDelegate?
    
    //MARK:- Views Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    //MARK:- Read image
    func setupImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.view.addSubview(imagePickerController.view)
        self.addChildViewController(imagePickerController)
        imagePickerController.didMove(toParentViewController: self)
    }
}

extension MediaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion:{
            self.delegate?.didSelectProfileImage(mediaViewController:self, image: image)
        })
    }
}
