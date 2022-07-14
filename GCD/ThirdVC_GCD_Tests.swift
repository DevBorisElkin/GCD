//
//  ThirdVC_GCD_Tests.swift
//  GCD
//
//  Created by test on 14.07.2022.
//

import UIKit

class ThirdVC_GCD_Tests: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func onClick_RunTests1Button(_ sender: Any) {
        loadRandomImage_1()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func loadRandomImage_1(){
        
        var queue = DispatchQueue.global(qos: .utility)
        
        var imageURL = URL(string: "https://picsum.photos/5000/5000")
        
        // when this is set to 'sync', main thread will stop executing, and will wait until this process in a different quque finished executing, then, will start executing code below
        queue.sync { [weak self, imageURL] in
            guard let url = imageURL, let imageData = try? Data(contentsOf: url) else{
                print("Unknown error")
                return
            }
            
            print("Loading image process ended")
            
            sleep(5)
            print("Delay ended")
            
            if(self == nil){
                print("Thread aborted because VC is destroyed")
            }
            
            // if changed to sync this should make a deadlock since this operation will be added to main queue as a last one, and main thread waits for this big block of code to finish,
            DispatchQueue.main.async {
                self?.imageView.image = UIImage(data: imageData)
            }
            //print("Process of setting image within thread ended")
        }
        print("URL loading image process ended")
        
    }
    

    

}
