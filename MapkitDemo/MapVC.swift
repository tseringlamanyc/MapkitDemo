//
//  ViewController.swift
//  MapkitDemo
//
//  Created by Tsering Lama on 2/24/20.
//  Copyright © 2020 Tsering Lama. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textField: UITextField!
    
    private var userTrackingButton: MKUserTrackingButton!
    
    private let locationSession = CoreLocationSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        textField.delegate = self
        userTrackingButton = MKUserTrackingButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        mapView.addSubview(userTrackingButton)
        userTrackingButton.mapView = mapView
        loadMap()
    }
    
    private func concertPlacenameToCoordinate(placename: String) {
        locationSession.placemarkToCoordinate(address: placename) { (result) in
            switch result {
            case .failure(let eeror):
                print("geocoding error \(eeror)")
            case .success(let coordinate):
                print("coordinate: \(coordinate)")
                
                // set map view at given coordinate
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1600, longitudinalMeters: 1600)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    private func loadMap() {
        let annotations = makeAnnotation()
        mapView.addAnnotations(annotations)
    }
    
    private func makeAnnotation() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for location in Location.getLocations() {
            let annotation = MKPointAnnotation()
            annotation.title = location.title
            annotation.coordinate = location.coordinate
            annotations.append(annotation)
        }
        return annotations
    }

}

extension MapVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let searchText = textField.text, !searchText.isEmpty else {
            return true 
        }
        
        concertPlacenameToCoordinate(placename: searchText)
        
        return true
    }
}
