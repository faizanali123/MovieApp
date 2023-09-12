//
//  Constants.swift
//
//  MovieApp
//
//  Created by Faizan Ali on 11/09/2023.
//

import Foundation
import UIKit
import Alamofire

class Constants {
    
    //BaseUrl
    static let BaseUrl = "https://api.themoviedb.org/3/"
        
    //error message
    static let InternetError = "Internal error occur."
    
    static var headers = ["Content-Type":"application/json",
               "Authorization" : "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMzQ1MDcwYzE0NjY2NDQwNWIzMWUzYjVlNmIxNTBmNCIsInN1YiI6IjY0ZmYzMDY5MmRmZmQ4MDEzYmNkMzEwZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.e6le3rULiPi4pwjvsywD-ZAom_do7AqiM4TqRAv7ADg"] as HTTPHeaders
    
    static var secondaryHeaders = ["Content-Type": "application/json", "Authorization": "Bearer c345070c146664405b31e3b5e6b150f4"] as HTTPHeaders
}

extension UIView {
   
    static let loadingViewTag = 1938123987
   
    func showLoading(style: UIActivityIndicatorView.Style = .white) {
        var loading = viewWithTag(UIImageView.loadingViewTag) as? UIActivityIndicatorView
            if loading == nil {
                loading = UIActivityIndicatorView(style: style)
            }

            loading?.translatesAutoresizingMaskIntoConstraints = false
            loading!.startAnimating()
            loading!.hidesWhenStopped = true
            loading?.tag = UIView.loadingViewTag
            addSubview(loading!)
          loading?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            loading?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    func stopLoading() {
        let loading = viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
            loading?.stopAnimating()
            loading?.removeFromSuperview()
    }
}


