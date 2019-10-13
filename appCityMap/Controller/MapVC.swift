//
//  MapVC.swift
//  appCityMap
//
//  Created by Dante on 2019/10/13.
//  Copyright © 2019 cinderella. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var mapView: MKMapView!
   
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullUpView: UIView!
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius : Double = 1000
    
    var screenSize = UIScreen.main.bounds
    
    var spinner : UIActivityIndicatorView?
    var progressLbl:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate=self
        locationManager.delegate = self
        configureLocationServices()
        addDoubleTap()
    }
    func addDoubleTap(){
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }

    func addSwipe(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    func animateViewUP(){
        pullUpViewHeightConstraint.constant = 300
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }

    }
    
    @objc func animateViewDown(){
        pullUpViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width/2) - ((spinner?.frame.width)!/2), y: 150)
        spinner?.style = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spinner?.startAnimating()
        pullUpView.addSubview(spinner!)
    }
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        if authorizationStatus == . authorizedAlways || authorizationStatus == .authorizedWhenInUse{
                  centerMapOnUserLocation()
              }
    }
}

extension MapVC:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    

    func centerMapOnUserLocation(){
        guard let coordinate = locationManager.location?.coordinate else{ return }
        debugPrint(coordinate)
        //let newCoord = CLLocationCoordinate2D(latitude: coordinate.latitude/2, longitude: coordinate.longitude/2)
        let coordinateRegion = MKCoordinateRegion(center: coordinate,latitudinalMeters: regionRadius*3, longitudinalMeters: regionRadius*3)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer){
        removePin()
        animateViewUP()
        addSwipe()
        addSpinner()
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint,toCoordinateFrom: mapView)
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegion(center: touchCoordinate,latitudinalMeters: regionRadius*3, longitudinalMeters: regionRadius*3)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func removePin(){
        for annotation in mapView.annotations{
            mapView.removeAnnotation(annotation)
        }
    }
  }

extension MapVC:CLLocationManagerDelegate{
    func configureLocationServices() {
        if authorizationStatus == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }else{
            return
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
}
