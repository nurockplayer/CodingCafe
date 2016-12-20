//
//  ViewController.swift
//  CodingCafe
//
//  Created by 余佳恆 on 2016/12/20.
//  Copyright © 2016年 icdt. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getCafCoordinate() {
        
        let API = "https://cafenomad.tw/api/v1.0/cafes"
        
        Alamofire.request(API).responseJSON { (response) in
            switch response.result.isSuccess {
            case true:
                
                print("response = \(response)")
                
                if let value = response.result.value {
                    print("value = \(value)")
                }
            case false:
                print(response.result.error ?? "response result error")
            }
        }
    }
}

