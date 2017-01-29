//
//  Communicator.swift
//  CodingCafe
//
//  Created by 余佳恆 on 2017/1/15.
//  Copyright © 2017年 icdt. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Communicator: NSObject {
    
    private static var _SingletonCommunicator: Communicator? = nil
    
    static func shareInstance() -> Communicator {
        
        if _SingletonCommunicator == nil {
            _SingletonCommunicator = Communicator()
        }
        
        return _SingletonCommunicator!
    }
    

    let API = "https://cafenomad.tw/api/v1.0/cafes"
    
    
    func getCafeCoordinate(completionHandler: @escaping (Any?, Error?) -> ()) {
        
        Alamofire.request(API, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result.isSuccess {
            case true:
                completionHandler(response.result.value , nil)
            case false:
                print("error: \(response.result.error)")
            }
        }
    }
}
