//
//  PlaceClass.swift
//  hw5_xcodeproj
//
//  Created by S on 2/8/20.
//  Copyright © 2020 SH. All rights reserved.
//

import Foundation
import MapKit

let debug = true

class Place: MKPointAnnotation {
    
    init(name: String, longDescription: String) {
        super.init()
        
        self.title = name
        self.subtitle = longDescription
    }
  
}


class PlaceMarkerView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
      willSet {
        clusteringIdentifier = "Place"
        displayPriority = .defaultLow
        markerTintColor = .systemRed
        glyphImage = UIImage(systemName: "pin.fill")
        }
  }
}


public class DataManager {
  
    // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()

    //This prevents others from using the default '()' initializer
    fileprivate init() {}
    
    // `static`: Type method
    static func loadLocationDataFromPlist() -> NSDictionary? {
        var dataDct: NSDictionary?
        if let path = Bundle.main.path(forResource: "Data", ofType: "plist") {
            dataDct = NSDictionary(contentsOfFile: path)
            return dataDct
        }
        return nil
    }
    
    static func saveFavorites(_ selectedAnnotation: MKAnnotation) {
        var favPlacesAnnoDct = UserDefaults.standard.object(forKey: "favPlacesAnnoDct")
            as? Dictionary<String, Dictionary<String, Any>> ?? Dictionary<String, Dictionary<String, Any>>()
        
        let placeSubDct = [
            "lat": selectedAnnotation.coordinate.latitude,
            "long": selectedAnnotation.coordinate.longitude
        ]
        
        favPlacesAnnoDct[selectedAnnotation.title!!] = placeSubDct
        UserDefaults.standard.set(favPlacesAnnoDct, forKey: "favPlacesAnnoDct")
        
        if debug {
            print("Added \(selectedAnnotation.title!!) into favorite dict.")
            print(favPlacesAnnoDct)
        }
    }
        
    static func deleteFavorite(_ selectedAnnotation: MKAnnotation) {
        var favPlacesAnnoDct = UserDefaults.standard.object(forKey: "favPlacesAnnoDct")
            as? Dictionary<String, Dictionary<String, Any>> ?? Dictionary<String, Dictionary<String, Any>>()
        favPlacesAnnoDct.removeValue(forKey: selectedAnnotation.title!!)
        UserDefaults.standard.set(favPlacesAnnoDct, forKey: "favPlacesAnnoDct")
        
        if debug {
            print("Removed \(selectedAnnotation.title!!) from favorite dict.")
            print(favPlacesAnnoDct)
        }
    }

    static func listFavorites() {}
}


//protocol PlacesFavoritesDelegate: class {
//    func favoritePlace(name: String) -> Void
//}
