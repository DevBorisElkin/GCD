//
//  SecondViewController.swift
//  GCD
//
//  Created by test on 11.07.2022.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var image: UIImage? {
        get{
            return imageView.image
        }
        set{
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    fileprivate var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
    }
    
    fileprivate func fetchImage(){
        
        //imageURL = URL(string: "https://en.wikipedia.org/wiki/Main_Page#/media/File:Mario_Draghi_2021_cropped.jpg")
        //imageURL = URL(string: "https://picsum.photos/200/300")
        
        imageURL = URL(string: "https://picsum.photos/2000/3000")
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        // I wrote it from memory but it's better to learn something new
//        DispatchQueue.main.async { [weak self, imageURL] in
//            guard let url = imageURL, let imageData = try? Data(contentsOf: url) else{
//                print("Unknown error")
//                return
//            }
//
//            self?.image = UIImage(data: imageData)
//        }
        
        var queue = DispatchQueue.global(qos: .utility)
        
        queue.async { [weak self, imageURL] in
            guard let url = imageURL, let imageData = try? Data(contentsOf: url) else{
                print("Unknown error")
                return
            }

            DispatchQueue.main.async {
                self?.image = UIImage(data: imageData)
            }
        }
    }
}
