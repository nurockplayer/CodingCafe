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
    
    
    func getCafeCoordinate(completion: @escaping () -> ()) {
        
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
                            
                            cafeInformation.arrayDic += [dicString]
                            cafeInformation.arrayTitle += [json[Int(key)!]["name"].string ?? ""]
                            
//                            self.setupData(dic: dicString)
                        }
                    }
                }
            case false:
                print("error: \(response.result.error)")
            }
        }
    }
}
