//
//  MoviesTableViewCell.swift
//  MovieApp
//
//  Created by Faizan Ali on 11/09/2023.
//

import UIKit
import Kingfisher

class MoviesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupView(withMovieData: Movie) {
        
        let url = URL(string: Constants.BaseUrl+withMovieData.posterPath)
        
        getImageFromURL(url: url!) { image in
           
        }
        
        
        self.titleLabel.text = withMovieData.title
        self.descriptionLabel.text = withMovieData.overview
        self.ratingLbl.text = "\(withMovieData.vote.description)/10"
        self.languageLabel.text = withMovieData.language
    }
    
    func getImageFromURL(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        self.imgView.showLoading()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //            request.headers = Constants.secondaryHeaders
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer c345070c146664405b31e3b5e6b150f4"
        ]
        request.allHTTPHeaderFields = headers
        //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let imageData = data else {
                completion(nil) // Notify with nil image in case of an error
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: imageData) {
                    self.imgView.stopLoading()
                    self.imgView.image = image
                    completion(image) // Notify with the downloaded image
                } else {
                    completion(nil) // Notify with nil image if image data is invalid
                }
            }
        }.resume()
        
    }
}
