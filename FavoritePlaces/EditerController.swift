//
//  EditerController.swift
//  FavoritePlaces
//
//  Created by Анна Заблуда on 29.04.2021.
//

import UIKit

class EditerController: UITableViewController {

    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var plaseLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var newPlace: Place?
    var imageIsChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        imagePlace.contentMode = .scaleAspectFit
        
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    // Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(sourse: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(sourse: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(camera)
            alertController.addAction(photo)
            alertController.addAction(cancel)
            
            present(alertController, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    func addPlace() {
        
        let addImage: UIImage
        
        if imageIsChange {
            addImage = imagePlace.image!
        } else {
            addImage = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        newPlace = Place(name: placeName.text!,
                         location: plaseLocation.text,
                         type: placeType.text,
                         image: addImage,
                         imagePlaceName: nil)
    }

    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension EditerController: UITextFieldDelegate {
    
    //hide the keyboard on Done
    
    func textFieldShouldReturn(_ textFild: UITextField) -> Bool {
        textFild.resignFirstResponder()
        return true
    }
    
    @objc func textFieldChanged() {
        
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

// MARK: - work with image

extension EditerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePlace.image = info[.editedImage] as? UIImage
        imagePlace.contentMode = .scaleAspectFill
        imagePlace.clipsToBounds = true
        imageIsChange = true
        dismiss(animated: true)
    }
}
