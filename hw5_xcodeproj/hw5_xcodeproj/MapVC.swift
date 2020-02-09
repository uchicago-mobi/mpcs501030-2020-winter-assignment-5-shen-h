//
//  ViewController.swift
//  hw5_xcodeproj
//
//  Created by S on 2/8/20.
//  Copyright © 2020 SH. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeDescLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let dataDct = DataManager.loadLocationDataFromPlist()
        
        let regionArr = dataDct!["region"] as! [NSNumber]
        let regionLat = regionArr[0] as! Double
        let regionLong = regionArr[1] as! Double
        let regionLatDelta = regionArr[2] as! Double
        let regionLongDelta = regionArr[3] as! Double
        
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        
        let center = CLLocationCoordinate2DMake(regionLat, regionLong)
        let span = MKCoordinateSpan.init(latitudeDelta: regionLatDelta, longitudeDelta: regionLongDelta)
        let viewRegion = MKCoordinateRegion.init(center: center, span: span)
        mapView.setRegion(viewRegion, animated: true)
        
        mapView.register(PlaceMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let placesArr = dataDct!["places"] as! [Dictionary<String, Any>]
        for placeDct in placesArr {
            let name = placeDct["name"] as! String
            let longDescription = placeDct["description"] as! String
            let lat = placeDct["lat"] as! Double
            let long = placeDct["long"] as! Double
            
            let placeAnnotation = Place(name: name, longDescription: longDescription)
            placeAnnotation.coordinate = CLLocationCoordinate2DMake(lat, long)
            
            mapView.addAnnotation(placeAnnotation)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    var selectedAnnotation: MKAnnotation!
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation!
        let placeName = selectedAnnotation.title!
        let placeLongDesc = selectedAnnotation.subtitle!
        
        placeNameLabel.text = placeName
        placeDescLabel.text = placeLongDesc
        
        let favPlacesAnnoDct = UserDefaults.standard.object(forKey: "favPlacesAnnoDct")
            as? Dictionary<String, Dictionary<String, Any>> ?? Dictionary<String, Dictionary<String, Any>>()
        favoriteBtn.isSelected = favPlacesAnnoDct[placeName!] != nil
        
        self.selectedAnnotation = selectedAnnotation
        
        if debug {
            print(favPlacesAnnoDct)
        }
    }

    @IBAction func touchedFavoriteBtn(_ favBtn: UIButton) {
        if self.selectedAnnotation == nil {
            return
        } else if favBtn.isSelected {
            favBtn.isSelected = false
            DataManager.deleteFavorite(self.selectedAnnotation)
        } else {
            // Not favorited. Add to favorite.
            favBtn.isSelected = true
            DataManager.saveFavorites(self.selectedAnnotation)
            
        }
    }
}


//extension MapVC: PlacesFavoritesDelegate {
//    func favoritePlace(name: String) {
//    // Update the map view based on the favorite
//    // place that was passed in
//
//        
//    }
//}
