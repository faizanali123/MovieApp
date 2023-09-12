//
//  MovieModel.swift
//  MovieApp
//
//  Created by Faizan Ali on 11/09/2023.
//

import Foundation
import RealmSwift
import SwiftyJSON

class MovieModel: Object {
    
    @objc dynamic var page: Int = 0
    
     var results: [Movie] = []
    
    
    func updateModelWithJSON(json: JSON){
        
        page = json["page"].intValue
        
        let resultsArray = json["result"].arrayValue
        
        for item in resultsArray {
            
            let model = Movie()
            model.updateModelWithJSON(json: item)
            results.append(model)
            
        }
    }
}

class Movie: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var language: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var posterPath: String = ""
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var vote: Int = 0
    
    func updateModelWithJSON(json: JSON){
        
        id = json["id"].intValue
        language = json["original_language"].stringValue
        title = json["original_title"].stringValue
        overview = json["overview"].stringValue
        posterPath = json["poster_path"].stringValue
        releaseDate = json["release_date"].stringValue
        vote = json["vote_average"].intValue
    }
}

