//
//  ViewController.swift
//  MyMap
//
//  Created by 林佳傳 on 2019/5/10.
//  Copyright © 2019 jiazhuan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var mapView:MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate
        mapView.delegate = self
        locationManager.delegate = self
        
        //MapView property
        mapView.showsUserLocation = true
        
        //LocationManager Property
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        centerUserLocation()
        addGesture()
        
    }
    
    @IBAction func getUserLocation(sender:UIButton){
        UIView.animate(withDuration: 1) {
            self.centerUserLocation()
        }
    }
    
    
    func centerUserLocation(){
        if let coordinate = locationManager.location?.coordinate{
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.0018, longitudeDelta: 0.0018)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        

    }
    func addGesture(){
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(getUserAddress(sender:)))
        longPressed.delegate = self
        longPressed.minimumPressDuration = 2
        view.addGestureRecognizer(longPressed)
        
    }
    
    @objc func getUserAddress(sender:UILongPressGestureRecognizer){
        if sender.state == UILongPressGestureRecognizer.State.began{
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            
            let touchPoint = sender.location(in: mapView)
            let pointCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            annotation.coordinate = pointCoordinate
//            annotation.title = "My location"
//            annotation.subtitle = "Location Description."
            let userLocation:CLLocation = CLLocation(latitude: pointCoordinate.latitude, longitude: pointCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(userLocation) { (clplacemarks, error) in
                if let error = error{
                    print(error.localizedDescription)
                }else{
                    if let placemarks = clplacemarks{
                        let placemark = placemarks[0]
                        annotation.title = placemark.locality
                        annotation.subtitle = placemark.name
                    }
                }
                
                
            }
            mapView.addAnnotation(annotation)
        }
    }


}

