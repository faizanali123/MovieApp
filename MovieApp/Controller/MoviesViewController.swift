//
//  ViewController.swift
//  MovieApp
//
//  Created by Faizan Ali on 11/09/2023.
//

import UIKit
import RealmSwift
import Loaf

class MoviesViewController: UIViewController {

    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTxtField: UITextField!
    
    //variables
    var cellName = "MoviesTableViewCell"
    var movieModels = [Movie]()
    
    var movieNamesSearch: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //made seperate function so that our viewDidLoad not look like spaghetti
        setUI()
    }
    
    func setUI() {
        //setuping our inital views and one time call api
        registerTableViewCell()
        self.getMovies(endPoint: .getMovies)
    }
    
    func getMovies(endPoint: EndPoint){
        
        if !Reachability.isConnectedToNetwork() {
            
            //showing alert to notify users that your internet is disconnected
            Loaf("your are offline.", sender: self).show()
            
//            self.refresher.endRefreshing()
            
            let realm = try! Realm()

            self.movieModels.removeAll()
            
            //appending both models with data from Realm
            self.movieModels = Array(realm.objects(Movie.self))
            self.movieNamesSearch = Array(realm.objects(Movie.self))
            
            self.tableView.reloadData()
            
        } else {
            
            //using singleton approach to call api so that we don't need to provide body in every controller
            API.sharedInstance.executeAPI(type: endPoint, method: .get) { (status, result, message) in
                
                DispatchQueue.main.async {

                    if (status == .success){
                        
//                        self.refresher.endRefreshing()
                        
                        let realm = try! Realm()
                        
                        realm.beginWrite()
                        realm.deleteAll()
                        
                        try! realm.commitWrite()
                        
                        self.movieModels.removeAll()
                        self.movieNamesSearch.removeAll()
                        
                        for item in result["results"].arrayValue {
                            
                            //writing into our Realm Model so we can get data in offline mode
                            try! realm.write {
                                
                                let model = Movie()
                                model.updateModelWithJSON(json: item)
                                realm.add(model)
                                
                                print(result)
                                self.movieModels.append(model)
                                
                            }
                        }
                        
                        //appending into this model for searching functionality
                        self.movieNamesSearch = self.movieModels
                        
                        self.tableView.reloadData()
                        
                    } else {
                        
                        //showing alert in case of any failure occur in api response to notify user
                        Loaf(message, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show(.custom(2)) { (action) in
                        }
                    }
                }
                
            }
        }
    }
    
    func registerTableViewCell() {
        let nib = UINib(nibName: cellName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellName)
    }
    
    
    
    @IBAction func clearBtnTapped(_ sender: Any) {
        
        //it will clear search textfield and hide keyboard either with default data
        self.view.endEditing(true)
        self.searchTxtField.text = ""
        self.movieNamesSearch = self.movieModels
        self.tableView.reloadData()
    }
    

}

//seperate extension for tablew view delegates
extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //applying this condition in order to differentiate weither is searching is in action or not
        if movieNamesSearch.count == movieModels.count {
            return movieModels.count
        } else {
            return movieNamesSearch.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? MoviesTableViewCell else {return UITableViewCell()}
                
        //applying this condition in order to differentiate weither is searching is in action or not
        if movieNamesSearch.count == movieModels.count {
            
            //providing data to table view cell so it will populate data into its subviews
            cell.setupView(withMovieData: movieModels[indexPath.row])
        } else {
            cell.setupView(withMovieData: movieNamesSearch[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MoviesDetailViewController") as! MoviesDetailViewController
        vc.movie = self.movieModels[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//separate extension for textfield delegates function
extension MoviesViewController: UITextFieldDelegate {
   
    
    //For applying filtering
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //using approach of HOF Higher Order Function to filter data from main model array to our search model array with identification of a back space tapped
        movieNamesSearch = string.isEmpty ? movieModels : movieModels.filter{ $0.title.contains(string)}
        self.tableView.reloadData()
        
        return true
    }
}

