//
//  MapViewController.swift
//  CodingCafe
//
//  Created by 余佳恆 on 2017/1/16.
//  Copyright © 2017年 icdt. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let API = "https://cafenomad.tw/api/v1.0/cafes"

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var detailView: UIView!
    @IBOutlet var starView: UIView!
    
    @IBOutlet var image_Star: UIImageView!
    
    @IBOutlet var label_Name: UILabel!
    @IBOutlet var label_Address: UILabel!
    
    
    
    @IBOutlet var label_Wifi: UILabel!
    @IBOutlet var label_Quiet: UILabel!
    @IBOutlet var label_Seat: UILabel!
    @IBOutlet var label_Tasty: UILabel!
    @IBOutlet var label_Cheap: UILabel!
    @IBOutlet var label_Music: UILabel!
    
    var locationManager : CLLocationManager!
    var selectAnnLocation : CLLocationCoordinate2D?
    var currentLocation : CLLocationCoordinate2D?
    var annationTitle : String?

    var arrayTitle = [String]()
    var arrayDic = [Dictionary<String, String>]()
    var fbUrl = ""

    var frame_DetailView = CGRect()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        frame_DetailView = detailView.frame

        mapView.frame = self.view.frame
        
        self.detailView.frame = CGRect(x: self.detailView.frame.origin.x,
                                       y: self.view.frame.maxY,
                                       width: self.frame_DetailView.size.width,
                                       height: self.frame_DetailView.size.height)
        
        
        
        let size = starView.frame.size
        
        label_Wifi.sizeToFit()
        starView.frame = CGRect(origin: CGPoint(x: label_Wifi.frame.maxX, y: label_Wifi.frame.origin.y), size: size)

        label_Quiet.sizeToFit()
        let sView1 = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: starView)) as! UIView
        sView1.frame = CGRect(origin: CGPoint(x: label_Quiet.frame.maxX, y: label_Quiet.frame.origin.y), size: size)
        detailView.addSubview(sView1)

        label_Seat.sizeToFit()
        let sView2 = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: starView)) as! UIView
        sView2.frame = CGRect(origin: CGPoint(x: label_Seat.frame.maxX, y: label_Seat.frame.origin.y), size: size)
        detailView.addSubview(sView2)
        
        label_Tasty.sizeToFit()
        let sView3 = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: starView)) as! UIView
        sView3.frame = CGRect(origin: CGPoint(x: label_Tasty.frame.maxX, y: label_Tasty.frame.origin.y), size: size)
        detailView.addSubview(sView3)

        label_Cheap.sizeToFit()
        let sView4 = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: starView)) as! UIView
        sView4.frame = CGRect(origin: CGPoint(x: label_Cheap.frame.maxX, y: label_Cheap.frame.origin.y), size: size)
        detailView.addSubview(sView4)

        label_Music.sizeToFit()
        let sView5 = NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: starView)) as! UIView
        sView5.frame = CGRect(origin: CGPoint(x: label_Music.frame.maxX, y: label_Music.frame.origin.y), size: size)
        detailView.addSubview(sView5)
        
        
        
         self.getCafeCoordinate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus() == .denied {
            
            let alertController = UIAlertController(
                title: "請開啟定位權限",
                message:"如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            alertController.addAction(okAction)
            show(alertController, sender: self)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getCafeCoordinate() {
        
        Alamofire.request(API, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result.isSuccess {
            case true:
                
                if let value = response.result.value {
                    
                    DispatchQueue.global().async {
                        
                        let json = JSON(value)
                        
                        for (key,_):(String, JSON) in json {
                            
                            let dicValue = json[Int(key)!].dictionaryValue
                            var dicString : Dictionary<String, String> = [:]
                            dicValue.forEach { dicString[$0.0] = String(describing: $0.1) }
                            
                            self.arrayDic += [dicString]
                            self.arrayTitle += [json[Int(key)!]["name"].string ?? ""]
                            
                            
                            self.setupData(dic: dicString)
                        }
                    }
                }
            case false:
                print("error: \(response.result.error)")
            }
        }
    }
    
    func setupData(dic: Dictionary<String, String>) {
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            
            let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(dic["latitude"]!)!, CLLocationDegrees(dic["longitude"]!)!)
            
            let cafeAnnotation = MKPointAnnotation()
            cafeAnnotation.coordinate = coordinate
            cafeAnnotation.title = dic["name"]
            
            
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
        currentLocation = CLLocationCoordinate2D(latitude: LoactionCoordinate.latitude, longitude: LoactionCoordinate.longitude)
        let _span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005);
        
        self.mapView.setRegion(MKCoordinateRegion(center: currentLocation!, span: _span), animated: true);
        //        mapView.setCenter(currentLocation!, animated: true)
        if currentLocation != nil {
            manager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var cafeAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if cafeAnnotation == nil {
            cafeAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        
        //        let btn_Navigation = UIButton(type: .detailDisclosure)
        //        btn_Navigation.addTarget(self, action: #selector(btn_NavigationPress), for: .touchUpInside)
        //        cafeAnnotation?.rightCalloutAccessoryView = btn_Navigation
        //        cafeAnnotation?.canShowCallout = true
        
        return cafeAnnotation
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        selectAnnLocation = view.annotation!.coordinate
        annationTitle = view.annotation!.title!
        

        UIView.animate(withDuration: 0.2) {
            self.detailView.frame = self.frame_DetailView
            
            var frame = mapView.frame
            frame.size.height = self.frame_DetailView.origin.y
            mapView.frame = frame
        }
        
        
        let indexNumber = arrayTitle.index(of: annationTitle!)
        
        let dic = arrayDic[indexNumber!]
        
        label_Name.text = dic["name"] ?? ""
        label_Name.sizeToFit()

        label_Address.text = dic["address"] ?? ""
        label_Address.sizeToFit()
        //        btn_Navigation.frame.origin.x = label_Address.frame.maxX + 5
        fbUrl = dic["url"] ?? ""
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            mapView.frame = self.view.frame
            
            self.detailView.frame = CGRect(x: self.detailView.frame.origin.x,
                                           y: self.view.frame.maxY,
                                           width: self.frame_DetailView.size.width,
                                           height: self.frame_DetailView.size.height)
            
            
        }) { (finished) in
//            self.detailView.isHidden = true
        }
        
    }
    
    
    
    
    @IBAction func btn_FB(_ sender: Any) {
        if let url = URL(string: fbUrl) {
            UIApplication.shared.openURL(url)
        } else {
            let alertController = UIAlertController(
                title: "此店家無粉絲專頁",
                message:"",
                preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            alertController.addAction(okAction)
            show(alertController, sender: self)
        }
    }

    @IBAction func btn_Navigation(_ sender: Any) {
        if currentLocation == nil {
            return
        }
        
        let pA = MKPlacemark(coordinate: currentLocation!, addressDictionary: nil)
        let pB = MKPlacemark(coordinate: selectAnnLocation!, addressDictionary: nil)
        
        let miA = MKMapItem(placemark: pA)
        let miB = MKMapItem(placemark: pB)
        miA.name = "我的位置"
        miB.name = annationTitle
        
        let routes = [miA, miB]
        
        let opions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        MKMapItem.openMaps(with: routes, launchOptions: opions)

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}