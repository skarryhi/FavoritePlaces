//
//  MainTableCell.swift
//  FavoritePlaces
//
//  Created by Анна Заблуда on 28.04.2021.
//

import UIKit
import Cosmos

class MainTableCell: UITableViewCell {

    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var locationLable: UILabel!
    @IBOutlet weak var typeLable: UILabel!
    @IBOutlet weak var imagePlace: UIImageView! {
        didSet {
            imagePlace.layer.cornerRadius = imagePlace.frame.size.height / 2
            imagePlace.clipsToBounds = true
        }
    }
    @IBOutlet weak var cosmosView: CosmosView!{
        didSet {
            cosmosView.settings.updateOnTouch = false
        }
    }
    
}
