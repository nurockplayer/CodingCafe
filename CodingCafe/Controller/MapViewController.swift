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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {


    var communicator = Communicator()
    var cafeInfo = cafeInformation()

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var detailView: UIView!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var label_Name: UILabel!
    @IBOutlet var label_Address: UILabel!
    
    @IBOutlet var label_Wifi: UILabel!
    @IBOutlet var label_Quiet: UILabel!
    @IBOutlet var label_Seat: UILabel!
    @IBOutlet var label_Tasty: UILabel!
    @IBOutlet var label_Cheap: UILabel!
    @IBOutlet var label_Music: UILabel!
    
    @IBOutlet var image_Star1: UIImageView!
    @IBOutlet var image_Star2: UIImageView!
    @IBOutlet var image_Star3: UIImageView!
    @IBOutlet var image_Star4: UIImageView!
    @IBOutlet var image_Star5: UIImageView!
    @IBOutlet var image_Star6: UIImageView!
    
    
    var locationManager : CLLocationManager!
    var selectAnnLocation : CLLocationCoordinate2D?
    var currentLocation : CLLocationCoordinate2D?
    var annationTitle : String?

    var arrayTitle = [String]()
    var arrayDic = [Dictionary<String, String>]()
    var fbUrl = ""

    var array_LabelItem  = ["WIFI穩定","咖啡好喝","安靜程度","價格便宜","通常有位","裝潢音樂","有無限時","插座多寡","可站立工作"]
    let array_Item = ["wifi","tasty","quiet","cheap","seat","music"]

    var frame_DetailView = CGRect()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        communicator = Communicator.shareInstance()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let w = self.view.frame.size.width / 2 - 10
        var h = self.view.frame.size.height / 25
        h = self.view.frame.width / 15
        flowLayout.estimatedItemSize = CGSize(width: w, height: h)
//        flowLayout.minimumInteritemSpacing = 1
//        flowLayout.minimumLineSpacing = 1

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        frame_DetailView = detailView.frame

        mapView.frame = self.view.frame
        
        self.detailView.frame = CGRect(origin: CGPoint(x: self.detailView.frame.origin.x,
                                                       y: self.view.frame.maxY),
                                       size: self.frame_DetailView.size)
        
        label_Wifi.sizeToFit()
        label_Quiet.sizeToFit()
        label_Seat.sizeToFit()
        label_Tasty.sizeToFit()
        label_Cheap.sizeToFit()
        label_Music.sizeToFit()

        var frame = image_Star1.frame
        frame.origin.x = label_Wifi.frame.maxX + self.view.frame.size.width / 250
        image_Star1.frame = frame
        frame.origin.y = image_Star2.frame.origin.y
        image_Star2.frame = frame
        frame.origin.y = image_Star3.frame.origin.y
        image_Star3.frame = frame
        
        frame.origin = CGPoint(x: label_Tasty.frame.maxX + self.view.frame.size.width / 250,
                               y: image_Star4.frame.origin.y)
        image_Star4.frame = frame
        frame.origin.y = image_Star5.frame.origin.y
        image_Star5.frame = frame
        frame.origin.y = image_Star6.frame.origin.y
        image_Star6.frame = frame
        
        
        communicator.getCafeCoordinate { (resultValue, error) in
            
            if let value = resultValue {
                
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
        }
        
    
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
            cafeAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        
        cafeAnnotation?.annotation = annotation
        cafeAnnotation?.image = UIImage(named: "CafePin")
        
        
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
        
        fbUrl = dic["url"] ?? ""
        
        
        switch Float(dic["wifi"] ?? "0")! {
            
        case 1...5:

            image_Star1.image = UIImage(named: "starItem\(dic["wifi"]!)")
        default:
            image_Star1.image = UIImage(named: "starItem0")
        }
        
        switch Float(dic["quiet"] ?? "0")! {
            
        case 1...5:
            image_Star2.image = UIImage(named: "starItem\(dic["quiet"]!)")
        default:
            image_Star2.image = UIImage(named: "starItem0")
        }
        
        switch Float(dic["seat"] ?? "0")! {
        case 1...5:
            image_Star3.image = UIImage(named: "starItem\(dic["seat"]!)")
        
        default:
            image_Star3.image = UIImage(named: "starItem0")
        }
        
        switch Float(dic["tasty"] ?? "0")! {
        case 1...5:
            image_Star4.image = UIImage(named: "starItem\(dic["tasty"]!)")
            
        default:
            image_Star4.image = UIImage(named: "starItem0")
        }
        
        switch Float(dic["cheap"] ?? "0")! {
        case 1...5:
            image_Star5.image = UIImage(named: "starItem\(dic["cheap"]!)")
            
        default:
            image_Star5.image = UIImage(named: "starItem0")
        }
        
        switch Float(dic["music"] ?? "0")! {
        case 1...5:
            image_Star6.image = UIImage(named: "starItem\(dic["music"]!)")
            
        default:
            image_Star6.image = UIImage(named: "starItem0")
        }
        
//        mapView.setCenter(selectAnnLocation!, animated: false)
        collectionView.reloadData()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        UIView.animate(withDuration: 0.2) { 
            mapView.frame = self.view.frame
            
            self.detailView.frame = CGRect(x: self.detailView.frame.origin.x,
                                           y: self.view.frame.maxY,
                                           width: self.frame_DetailView.size.width,
                                           height: self.frame_DetailView.size.height)
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return array_LabelItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MapCollectionViewCell
        
        
        cell.label.text = array_LabelItem[indexPath.row]
        cell.label.sizeToFit()
        
        var frame = cell.imageView.frame
        frame.origin.x = cell.label.frame.maxX //+ self.view.frame.size.width / 375
        frame.origin.y = cell.label.frame.origin.y
        cell.imageView.frame = frame
        
        if annationTitle != nil && indexPath.row < 5 {
            let indexNumber = arrayTitle.index(of: annationTitle!)
            let dic = arrayDic[indexNumber!]
            
            switch Float(dic[array_Item[indexPath.row]] ?? "0")! {
                
            case 1...5:
                
                cell.imageView.image = UIImage(named: "starItem\(dic[array_Item[indexPath.row]]!)")
            default:
                cell.imageView.image = UIImage(named: "starItem0")
            }
        }
 
        return cell
    }

    
}
