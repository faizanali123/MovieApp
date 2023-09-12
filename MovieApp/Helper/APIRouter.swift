//
//  APIRouter.swift
//
//  MovieApp
//
//  Created by Faizan Ali on 11/09/2023.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias completionBlock = (StatusCodes,JSON,String) -> ()

enum EndPoint: String{
    
    case getMovies = "discover/movie"
   
}


enum StatusCodes {
    case success
    case failure
    case authError
}

class API: NSObject {
    
    static let sharedInstance = API()
    
    private override init() {
    }
    
    func executeAPI(type: EndPoint, method: HTTPMethod, params: Parameters? = nil, imageData: Data? = nil, completion: completionBlock?){
        
        URLCache.shared.removeAllCachedResponses()
        var request: DataRequest!
               
        let endPoint = type.rawValue
                        
        request = Alamofire.AF.request(Constants.BaseUrl + endPoint, method: method, parameters: params, encoding: method == .get ? URLEncoding.queryString : JSONEncoding.default, headers: Constants.headers)
        

            request.responseJSON { response in
                
                
                if response.response?.statusCode == 401{
                    completion?(.authError,JSON.null,"UnAuthorized User")
                    return
                }
                
                if let error = response.error{
                    var errorDescription = error.localizedDescription
                    if errorDescription == "The Internet connection appears to be offline."{
                        errorDescription = Constants.InternetError
                    }
                    completion?(.failure,JSON.null,errorDescription)
                    return
                }
                
                if let value = response.value {
                    let json = JSON(value)
                    
                    if (type == .getMovies){
                        if (response.response?.statusCode == 200){
                             completion?(.success,JSON(value),json["message"].stringValue)
                        }
                        else{
                            completion?(.failure,JSON(value),json["message"].stringValue)
                        }
                    }
                    else{
                        if json["code"].stringValue == "0"{
                            completion?(.success,JSON(value),json["message"].stringValue)
                        }
                        else{
                            completion?(.failure,JSON(value),json["message"].stringValue)
                        }
                    }
                    
                    return
                }
                
                completion?(.authError,JSON.null,"Something went wrong, please try again!")
            }
        
    }
    
}
