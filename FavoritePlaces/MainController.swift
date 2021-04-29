//
//  MainController.swift
//  FavoritePlaces
//
//  Created by Анна Заблуда on 28.04.2021.
//

import UIKit

class MainController: UITableViewController {
    
    var places = Place.getPlaces()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableCell

        let place = places[indexPath.row]
        
        cell.nameLable.text = place.name
        cell.locationLable.text = place.location
        cell.typeLable.text = place.type
        
        if place.image == nil {
            cell.imagePlace.image = UIImage(named: place.imagePlaceName!)
        } else {
            cell.imagePlace.image = place.image
        }
        
        cell.imagePlace.layer.cornerRadius = cell.imagePlace.frame.size.height / 2
        cell.imagePlace.clipsToBounds = true
        
        
        
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwintSegue(_ segue: UIStoryboardSegue) {
        
        guard let editingVC = segue.source as? EditerController else {
            return
        }
        
        editingVC.addPlace()
        places.append(editingVC.newPlace!)
        tableView.reloadData()
    }

}
