//
//  KMApiRequest.swift
//  KoreaMountains
//
//  Created by Emily on 2017. 9. 10..
//  Copyright © 2017년 Emily. All rights reserved.
//

import UIKit
import Alamofire

class KMApiRequest: NSObject {
    let baseUrl = "http://apis.data.go.kr/1400000/service/cultureInfoService"
    let requestId = "pZRIlvGmqCF7sJsIByGFWhK/h6C472Dhjm5VaCvlLdoJnrWTg7dYj061fhc0UzVjPLXYAGQ0lwaSduaILwSksQ=="
    
    func requestGetUrl(uri:String, params: [String:String]?, completion: @escaping ([String:Any]?) -> ()) {
        let urlStr = baseUrl + uri
        var parameters = [String : String]()
        
        if let params = params {
            parameters = params
        }
        
        parameters["serviceKey"] = requestId
        parameters["_type"] = "json"

        Alamofire.request(urlStr, parameters:parameters)
            .responseJSON { (DataResponse : DataResponse<Any>) in
                switch DataResponse.result {
                case .success:
                    if let result = DataResponse.value as? [String:Any],
                        let response = result["response"] as? [String:Any],
                        let body = response["body"] as? [String:Any],
                        let items = body["items"] as? [String:Any]
                        {
                        completion(items)
                    } else {
                        print("\(String(describing: DataResponse.value!))")
                        completion(nil)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
}
