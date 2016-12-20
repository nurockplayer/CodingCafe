//
//  ViewController.swift
//  CodingCafe
//
//  Created by 余佳恆 on 2016/12/20.
//  Copyright © 2016年 icdt. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON
import Alamofire

let API = "https://cafenomad.tw/api/v1.0/cafes"


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = CLLocationDistance(10)
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
        DispatchQueue.global().async {
            self.getCafeCoordinate()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1. 還沒有詢問過用戶以獲得權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus() == .denied {
//            showAlert("Location services were previously denied. Please enable location services for this app in Settings.")
        }
            // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getCafeCoordinate() {
        
        
        Alamofire.request(API).responseJSON { (response) in
            switch response.result.isSuccess {
            case true:
                
                if let value = response.result.value {
                    print(value)
                    
                    let json = JSON(value)
                    
                    for (key,_):(String, JSON) in json {
                        let address = json[Int(key)!]["address"].string!
                        let city = json[Int(key)!]["city"].string!
                        let latitude = json[Int(key)!]["latitude"].double ?? 0
                        let longitude = json[Int(key)!]["longitude"].double ?? 0
                        let name = json[Int(key)!]["name"].string ?? ""
//                        let wifi = json[Int(key)!]["wifi"].string ?? ""
                        self.setupData(lat: latitude, long: longitude, name: name)
                    }
                }
            case false:
                print("error: \(response.result.error)")
            }
        }
    }
    
    func setupData(lat: Double, long: Double, name: String) {
        // 1. checking region
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            // 2.prepare region
            let title = name
            let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(long))
            let regionRadius = 3000.0
            
            // 3. setting region
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 25.033408,
                                                                         longitude: 121.564099),
                                          radius: regionRadius, identifier: title)
            
            locationManager.startMonitoring(for: region)
            
            // 4. create annotation
            let cafeAnnotation = MKPointAnnotation()
            cafeAnnotation.coordinate = coordinate;
            cafeAnnotation.title = "\(title)";
            DispatchQueue.main.async {
                self.mapView.addAnnotation(cafeAnnotation)
            }
        }
        else {
            print("System can't track regions")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let LoactionCoordinate = locations.last!.coordinate
        let currentLocation  = CLLocationCoordinate2D(latitude: LoactionCoordinate.latitude, longitude: LoactionCoordinate.longitude)
        let _span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005);
        
        self.mapView.setRegion(MKCoordinateRegion(center: currentLocation, span: _span), animated: true);

    }
}

