//
//  PlaceModel.swift
//  FavoritePlaces
//
//  Created by Анна Заблуда on 29.04.2021.
//

import Foundation

struct Place {
    var name: String
    var location: String
    var type: String
    var image: String
    
    static let placesName = ["Зайка", "Ласточка", "Берег", "Наруто", "Рыба"]
    
    static func getPlaces() -> [Place] {
        var resPlaces = [Place]()
        
        for i in placesName {
            resPlaces.append(Place(name: i, location: "Anapa", type: "cafe", image: i))
        }
        
        return resPlaces
    }
}
