//
//  ViewController.swift
//  GCD
//
//  Created by test on 11.07.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func runMultithreadingTests_1(_ sender: Any) {
        print("runMultithreadingTests_1")
        multithreadingTests()
    }
    
    
    // ?
    // Barriers - Барьеры
    
    func multithreadingTests(){
        
        
        //var array = [Int]()
        // по идее тут должны теряться элементы - то есть в массиве не будет 10 элементов, будет другое значение
//        DispatchQueue.concurrentPerform(iterations: 10) { index in
//            //print(index)
//            array.append(index)
//        }
//        print(array)
        
        var array = SafeArray<Int>()
        DispatchQueue.concurrentPerform(iterations: 10) { (index) in
            array.append(element: index)
        }
        //array.updateElements()
        //array.printArray()
        print(array.elements)
    }
}


class SafeArray<Element> {
    private var array = [Element]()
    private let queue = DispatchQueue(label: "DispatchBarrier", attributes: .concurrent)
    
    public func append(element: Element){
        queue.async(flags: .barrier){
            self.array.append(element)
        }
    }
    
    public var elements: [Element]{
        var result = [Element]()
        queue.sync {
            result = self.array
        }
        
        return result
    }
    
    public func updateElements(){
        array = elements
    }
    
    public func printArray(){
        print(array)
    }
}

