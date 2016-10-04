//
//  DetailViewController.swift
//  Flicks
//
//  Created by Aneel Yelamanchili on 10/3/16.
//  Copyright © 2016 Aneel Yelamanchili. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

   
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary!
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        titleLabel.text = movie["title"] as? String
        
        overviewLabel.text = movie["overview"] as? String
        overviewLabel.sizeToFit()
        
        if let posterPath = movie["poster_path"] as? String {
            
            let baseSmallURL = "https://image.tmdb.org/t/p/w45"
            let baseLargeURL = "https://image.tmdb.org/t/p/original"
            
            loadImage(smallImageURL: baseSmallURL + posterPath, largeImageURL: baseLargeURL + posterPath, imageView: self.posterImageView)
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
