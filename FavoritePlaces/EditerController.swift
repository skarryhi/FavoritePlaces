//
//  EditerController.swift
//  FavoritePlaces
//
//  Created by Анна Заблуда on 29.04.2021.
//

import UIKit

class EditerController: UITableViewController {

    @IBOutlet weak var imagePlace: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    // Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(sourse: .camera)
            }
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(sourse: .photoLibrary)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(camera)
            alertController.addAction(photo)
            alertController.addAction(cancel)
            
            present(alertController, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }

}

extension EditerController: UITextFieldDelegate {
    
    //hide the keyboard on Done
    
    func textFieldShouldReturn(_ textFild: UITextField) -> Bool {
        textFild.resignFirstResponder()
        return true
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
        dismiss(animated: true)
    }
}
