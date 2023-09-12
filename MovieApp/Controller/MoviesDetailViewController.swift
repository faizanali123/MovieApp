//
//  MoviesDetailViewController.swift
//  MovieApp
//
//  Created by Faizan Ali on 12/09/2023.
//

import Foundation
import UIKit

class MoviesDetailViewController : UIViewController {
    
    //Outlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    //Variables
    var movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let url = URL(string: Constants.BaseUrl+movie.posterPath)
        self.imgView.showLoading()
        self.imgView.kf.setImage(with: url)
        self.titleLabel.text = movie.title
        self.releaseDateLabel.text = self.movie.releaseDate
        self.descriptionLabel.text = self.movie.overview
        self.languageLabel.text = self.movie.language
        self.ratingLabel.text = "\(self.movie.vote)/10"
    }
    
}
