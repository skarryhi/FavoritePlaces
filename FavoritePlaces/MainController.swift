//
//  MainController.swift
//  FavoritePlaces
//
//  Created by Анна Заблуда on 28.04.2021.
//

import UIKit
import RealmSwift

class MainController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var places: Results<Place>!
    var ascendingSorting = true
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        places = realm.objects(Place.self)
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    @IBAction func reversedSorting(_ sender: UIBarButtonItem) {
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
}
