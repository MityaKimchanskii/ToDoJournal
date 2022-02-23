//
//  ViewController.swift
//  ToDoJournal
//
//  Created by Mitya Kim on 2/16/22.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        alertPhotoCamera { source in
            self.chooseImagePicker(source: source)
        }
    }
    
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func weatherSwitchTapped(_ sender: UISwitch) {
        
    }
    
    @IBAction func notificationSwitchTapped(_ sender: UISwitch) {
        
    }
    
    @IBAction func soundSwitchTapped(_ sender: UISwitch) {
    }
    
    // MARK: - Helper Methods
    func updateViews() {
//        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.masksToBounds = true
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        profileImage.image = info[.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController {
    func alertPhotoCamera(completionHandler: @escaping (UIImagePickerController.SourceType) -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            let camera = UIImagePickerController.SourceType.camera
            completionHandler(camera)
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { _ in
            let photoLibrary = UIImagePickerController.SourceType.photoLibrary
            completionHandler(photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
}
