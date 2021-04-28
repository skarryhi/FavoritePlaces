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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableCell

        cell.nameLable.text = places[indexPath.row].name
        cell.locationLable.text = places[indexPath.row].location
        cell.typeLable.text = places[indexPath.row].type
        cell.imagePlace.image = UIImage(named: places[indexPath.row].image)
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

}
