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
    
    var queue: DispatchQueue?
    
    func multithreadingTests(){
        
        if(queue == nil){
            queue = DispatchQueue(label: "concurrentQueue", qos: .background, attributes: .concurrent)
            //queue = DispatchQueue(label: "concurrentQueue", qos: .userInitiated, attributes: .concurrent)
        }
        
        queue?.async{
            // по идее тут должны теряться элементы - то есть в массиве не будет 10 элементов, будет другое значение
            // но это работает так только если DispatchQueue.concurrentPerform вызывается в concurrentQuque, в serialQueue
            // все-таки без магии все элементы заполнятся без проблем
            var array = [Int]()
            DispatchQueue.concurrentPerform(iterations: 10) { index in
                //print(index)
                array.append(index)
            }
            print("not safe: \(array)")
            
            var array2 = SafeArray<Int>()
            DispatchQueue.concurrentPerform(iterations: 10) { (index) in
                array2.append(element: index)
            }
            //array2.updateElements()
            //array2.printArray()
            print("safe: \(array2.elements)")
        }
    }
}


class SafeArray<Element> {
    private var array = [Element]()
    private let queue = DispatchQueue(label: "DispatchBarrier", qos: .userInitiated, attributes: .concurrent)
    
    public func append(element: Element){
        //queue.async(flags: .barrier){
        queue.sync(flags: .barrier){
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

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

