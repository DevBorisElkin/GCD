//
//  FourthVC_DispatchGroup_Tests.swift
//  GCD
//
//  Created by test on 14.07.2022.
//

import UIKit

class FourthVC_DispatchGroup_Tests: UIViewController {

    @IBOutlet weak var image_1: UIImageView!
    @IBOutlet weak var image_2: UIImageView!
    @IBOutlet weak var image_3: UIImageView!
    @IBOutlet weak var image_4: UIImageView!
    
    static var urlStringToLoadImages = "https://picsum.photos/300/300"
    var urlToLoadImages = URL(string: "https://picsum.photos/2000/3000")!
    var concurrentQueue = DispatchQueue(label: "concurrentQueue", qos: .background, attributes: .concurrent)
    var dispatchGroup = DispatchGroup()
    
    var uiImage1: UIImage?
    var uiImage2: UIImage?
    var uiImage3: UIImage?
    var uiImage4: UIImage?
    
    @IBAction func onClick_LoadImagesOne(_ sender: Any) {
        loadImagesFirstWay()
    }
    
    @IBAction func onClick_LoadImagesTwo(_ sender: Any) {
        loadImagesSecondWay()
    }
    
    
    func loadImagesFirstWay(){
        print("Load Images First Way")
        typealias vc = FourthVC_DispatchGroup_Tests
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let viewController = self else{ print("VC was destroyed, returning"); return }
            
            viewController.concurrentQueue.async(group: viewController.dispatchGroup, qos: .background) { [weak self] in
                self?.uiImage1 = vc.loadImageForImageView(urlString: vc.urlStringToLoadImages)!
                print("image 1 loaded")
            }
            viewController.concurrentQueue.async(group: viewController.dispatchGroup, qos: .background) { [weak self] in
                self?.uiImage2 = vc.loadImageForImageView(urlString: vc.urlStringToLoadImages)!
                print("image 2 loaded")
            }
            viewController.concurrentQueue.async(group: viewController.dispatchGroup, qos: .background) { [weak self] in
                self?.uiImage3 = vc.loadImageForImageView(urlString: vc.urlStringToLoadImages)!
                print("image 3 loaded")
            }
            viewController.concurrentQueue.async(group: viewController.dispatchGroup, qos: .background) { [weak self] in
                self?.uiImage4 = vc.loadImageForImageView(urlString: vc.urlStringToLoadImages)!
                print("image 4 loaded")
            }
            viewController.concurrentQueue.async(group: viewController.dispatchGroup, qos: .background) { [weak self] in
                print("delay started")
                sleep(5)
                print("delay executed")
            }
            
            viewController.dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
                 print("4 images loaded successfully")
                
                self?.image_1.image = self?.uiImage1
                self?.image_2.image = self?.uiImage2
                self?.image_3.image = self?.uiImage3
                self?.image_4.image = self?.uiImage4
            }
            print("Code kept running below")
        }
    }
    
    func loadImagesSecondWay(){
        print("Load Images Second Way")
        typealias staticClass = FourthVC_DispatchGroup_Tests
        
        // Первый пример работал, второй тоже работает, но не так, как ожидалось, т.к. во втором случае код по очереди загружает изображения то есть нет асинхронности, одновременной загрузки
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let vc = self else { print("VC destroyed, returning"); return }
            
            var queue = DispatchQueue(label: "Some queue", attributes: .concurrent)
            
            vc.dispatchGroup.enter()
            queue.async {
                vc.uiImage1 = staticClass.loadImageForImageView(urlString: staticClass.urlStringToLoadImages)!
                print("image 1 loaded")
                vc.dispatchGroup.leave()
            }
            
            vc.dispatchGroup.enter()
            queue.async {
                vc.uiImage2 = staticClass.loadImageForImageView(urlString: staticClass.urlStringToLoadImages)!
                print("image 2 loaded")
                vc.dispatchGroup.leave()
            }
            
            vc.dispatchGroup.enter()
            queue.async {
                vc.uiImage3 = staticClass.loadImageForImageView(urlString: staticClass.urlStringToLoadImages)!
                print("image 3 loaded")
                vc.dispatchGroup.leave()
            }
            
            vc.dispatchGroup.enter()
            queue.async {
                vc.uiImage4 = staticClass.loadImageForImageView(urlString: staticClass.urlStringToLoadImages)!
                print("image 4 loaded")
                vc.dispatchGroup.leave()
            }
            
            vc.dispatchGroup.enter()
            queue.async {
                print("started delay")
                sleep(5)
                print("ended delay")
                vc.dispatchGroup.leave()
            }
            
            print("Code after groups code executed")
            
            vc.dispatchGroup.notify(queue: DispatchQueue.main){
                print("4 images loaded successfully")
               
               self?.image_1.image = self?.uiImage1
               self?.image_2.image = self?.uiImage2
               self?.image_3.image = self?.uiImage3
               self?.image_4.image = self?.uiImage4
                print("and have been successfully set")
            }
            
            
            //print("started waiting time out")
            // will not pass the code below unloss group finishes all tasks or time runs out
            // if theres less group.leave() than group.enter() then group will never call notify and all waiting finishes
            //let result = vc.dispatchGroup.wait(timeout: .now() + 15)
            //print("result of waiting for dispatch group: \(result)")
            
            
            
            // this thing is called for some reason only after vc.dispatchGroup.notify is called
            //print("Code kept running and went forward.")
            
            // will just wait until dispatch group successfully finishes work without timeout
            vc.dispatchGroup.wait()
            
            print("Code kept running and went forward___2.")
        }
    }
    
    static func loadImageForImageView(urlString: String, completion: (UIImage) -> ()){
        guard let url = URL(string: urlString) else {print("Wrong URL to load image"); return }
        guard let imageData = try? Data(contentsOf: url) else {print("Something is wrong with loaded image, returning"); return }
        completion(UIImage(data: imageData)!)
    }
    
    static func loadImageForImageView(urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else {print("Wrong URL to load image"); return nil }
        guard let imageData = try? Data(contentsOf: url) else {print("Something is wrong with loaded image, returning"); return nil }
        return UIImage(data: imageData)
    }
    
}
