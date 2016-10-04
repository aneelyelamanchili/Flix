//
//  NetworkRequest.swift
//  Flicks
//
//  Created by Aneel Yelamanchili on 10/3/16.
//  Copyright © 2016 Aneel Yelamanchili. All rights reserved.
//

import UIKit

func loadImage(smallImageURL: String, largeImageURL: String, imageView: UIImageView) {
    
    if let smallImageURL = URL(string: smallImageURL) {
        if let largeImageURL = URL(string: largeImageURL) {
    
            let smallImageRequest = URLRequest(url: smallImageURL)
            let largeImageRequest = URLRequest(url: largeImageURL)
            
            imageView.setImageWith(
                smallImageRequest,
                placeholderImage: UIImage(named: "placeholder_image"),
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    imageView.alpha = 0.0
                    imageView.image = smallImage
                    
                    UIView.animate(withDuration: 0.3,
                        animations: { () -> Void in
                            imageView.alpha = 1.0
                        },
                        completion: { (success) -> Void in
                            
                            imageView.setImageWith(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    imageView.image = largeImage
                                },
                                failure: { (request, response, error) -> Void in
                                    print("Failed to load large image!")
                                }
                            )
                        }
                    )
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    print("Failed to load small image!")
                }
            )
        }
        else {
            print("Invalid largeImageURL!")
        }
    }
    else {
        print("Invalid smallImageURL!")
    }
}
