//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Aneel Yelamanchili on 10/3/16.
//  Copyright © 2016 Aneel Yelamanchili. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    
    var endpoint: String!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
                
        //Initialize refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(_:)), for: .valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        //Initialize searchbar
        movieSearchBar.delegate = self

        collectionView.dataSource = self
        
        //Start loading icon
        MBProgressHUD.showAdded(to: self.view, animated: true)

        networkRequest()
        
        MBProgressHUD.hide(for: self.view, animated: true)
        //Stop loading icon
        
        
        // Do any additional setup after loading the view.
    }
    
    func networkRequest() {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task: URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                            //NSLog("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.filteredMovies = self.movies
                            self.collectionView.reloadData()
                            self.networkErrorLabel.isHidden = true
                    }
                }
                else {
                    self.networkErrorLabel.isHidden = false
                }
                
        });
        task.resume()
    }

    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {

        networkRequest()
        
        refreshControl.endRefreshing()
        
        movieSearchBar.text = ""
        movieSearchBar.showsCancelButton = false
        movieSearchBar.resignFirstResponder()
        filterMovies("")
    }
    
    func filterMovies(_ searchText: String) {
        
        if let movies = movies {
            
            filteredMovies = searchText.isEmpty ? movies : movies.filter(
                {
                    (movie: NSDictionary) -> Bool in
                    let title = movie["title"] as! String
                    return title.range(of: searchText, options: .caseInsensitive) != nil
            })
        }
        else {
            filteredMovies = nil
        }
        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterMovies(searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        movieSearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movieSearchBar.showsCancelButton = false
        movieSearchBar.text = ""
        movieSearchBar.resignFirstResponder()
        
        filterMovies("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        movieSearchBar.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "com.sparkasaurusRex.movieCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = filteredMovies![(indexPath as NSIndexPath).row]
        
        if let posterPath = movie["poster_path"] as? String {
            
            let baseSmallURL = "https://image.tmdb.org/t/p/w45"
            let baseLargeURL = "https://image.tmdb.org/t/p/original"
            
            loadImage(smallImageURL: baseSmallURL + posterPath, largeImageURL: baseLargeURL + posterPath, imageView: cell.posterImage)
            
        }
        
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        let movie = filteredMovies![(indexPath! as NSIndexPath).row]
        
        let detailViewController = segue.destination as! DetailViewController
        
        detailViewController.movie = movie
                
    }
    

}
