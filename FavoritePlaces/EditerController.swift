//
//  EditerController.swift
//  FavoritePlaces
//
//  Created by Анна Заблуда on 29.04.2021.
//

import UIKit
import Cosmos

class EditerController: UITableViewController {

    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var plaseLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var cosmosView: CosmosView!
    
    var imageIsChange = false
    var curentPlace: Place!
    var curentStar = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        placeImage.contentMode = .scaleAspectFit
        
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
        
        cosmosView.didTouchCosmos = { rating in
            self.curentStar = rating
        }
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
    
    func savePlace() {
        
        let addImage: UIImage
        
        if imageIsChange {
            addImage = placeImage.image!
        } else {
            addImage = #imageLiteral(resourceName: "imagePlaceholder")
        }
        let newPlace = Place(name: placeName.text!,
                             location: plaseLocation.text,
                             type: placeType.text,
                             imageData: addImage.pngData(),
                             rating: curentStar)
        if curentPlace != nil {
            try! realm.write {
                curentPlace?.name = newPlace.name
                curentPlace?.location = newPlace.location
                curentPlace?.type = newPlace.type
                curentPlace?.imageData = newPlace.imageData
                curentPlace?.rating = newPlace.rating
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
    }
    
    private func setupEditScreen() {
        if curentPlace != nil {
            setupNavigationBar()
            imageIsChange = true
            guard let data = curentPlace?.imageData, let image = UIImage(data: data) else { return }
            placeName.text = curentPlace?.name
            plaseLocation.text = curentPlace?.location
            placeType.text = curentPlace?.type
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            cosmosView.rating = curentPlace.rating
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        saveButton.isEnabled = true
        title = curentPlace?.name
        navigationItem.leftBarButtonItem = nil
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
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        imageIsChange = true
        dismiss(animated: true)
    }
}
