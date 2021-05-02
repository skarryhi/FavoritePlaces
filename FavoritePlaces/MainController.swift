//
//  MainController.swift
//  FavoritePlaces
//
//  Created by Анна Заблуда on 28.04.2021.
//

import UIKit
import RealmSwift

class MainController: UITableViewController {
    
    var places: Results<Place>!

    override func viewDidLoad() {
        super.viewDidLoad()

        places = realm.objects(Place.self)
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableCell

        let place = places[indexPath.row]

        cell.nameLable.text = place.name
        cell.locationLable.text = place.location
        cell.typeLable.text = place.type
        cell.imagePlace.image = UIImage(data: place.imageData!)
        

        cell.imagePlace.layer.cornerRadius = cell.imagePlace.frame.size.height / 2
        cell.imagePlace.clipsToBounds = true



        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.deleteObject(places[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellEditor" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let editerVC = segue.destination as! EditerController
            editerVC.curentPlace = places[indexPath.row]
        }
    }
    
    
    @IBAction func unwintSegue(_ segue: UIStoryboardSegue) {
        
        guard let editingVC = segue.source as? EditerController else {
            return
        }
        
        editingVC.savePlace()
        tableView.reloadData()
    }

}
