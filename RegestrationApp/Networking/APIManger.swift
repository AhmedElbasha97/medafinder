//
//  APIManger.swift
//  Media_Table
//
//  Created by ahmedelbasha on 4/24/20.
//  Copyright © 2020 ahmedelbasha. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
class APIManger: UIViewController {

   
        class func loadMedia(search: String, scope: String, completion: @escaping (_ error: Error?, _ receivedMedia: [Media]?, _ apiData: Int?) -> Void) {
            let parameters = [Params.media: scope, Params.term: search]
            
           Alamofire.request(Urls.media, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { response in
                guard response.error == nil else {
                    print(response.error!)
                    completion(response.error, nil, nil)
                    return
                }
                guard let data = response.data else {
                    print("didnt get any data from API")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let apiResults = try decoder.decode(Results.self, from: data).resultCount
                    let apiData = try decoder.decode(Results.self, from: data).results
                    
                    completion(nil, apiData, apiResults)
                }
                catch let error {
                    print(error)
                }
            }
        }
    }



