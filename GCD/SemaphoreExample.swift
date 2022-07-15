//
//  SemaphoreExample.swift
//  GCD
//
//  Created by test on 16.07.2022.
//

import UIKit

class SemaphoreExample: NSObject {

    public func startExample(){
        print("semaphore example")
        
        // for some reason it doesn't work as expected
        // but with little delays it works as expeted
        // that's probably because all threads are started approximately at the same time, but not forced to enter semaphore.wait in order from top to bottom
        // UPDATE: with qos .unspecified it endeed works unexpected, but with qos .userInteractive it works like a charm (2,3,4,1)
        // it looks like qos greatley impacts how fast blocks of code in queue will be executed
        
        // also for some reason with serial quque they executed one by one // that's because execution of blocks follows one by one also, like ->>>> 0-0-0-0
        
        var queue = DispatchQueue(label: "SomeQueue.Semaphore", qos: .userInteractive, attributes: .concurrent)
        
        //var queue = DispatchQueue(label: "SomeQueue.Semaphore - Serial queue")
        
        // value(X) determines how many participants can enter execution straight away, if we set value: 0 we need to call semaphore.signal() if we want for code to execute otherwise no thread will be able to enter
        var semaphore = DispatchSemaphore(value: 2)
        
//        for i in 1...4{
//            queue.async {
//                semaphore.wait(timeout: .distantFuture)
//
//                Thread.sleep(forTimeInterval: 4)
//                print("block \(i)")
//                semaphore.signal()
//            }
//        }
        
        queue.async {
            semaphore.wait(timeout: .distantFuture)
            
            Thread.sleep(forTimeInterval: 10)
            print("block 1")
            semaphore.signal()
        }
        //sleep(1)
        queue.async {
            semaphore.wait(timeout: .distantFuture)
            
            Thread.sleep(forTimeInterval: 5)
            print("block 2")
            semaphore.signal()
        }
        //sleep(1)
        queue.async {
            semaphore.wait(timeout: .distantFuture)
            
            //Thread.sleep(forTimeInterval: 0)
            print("block 3")
            semaphore.signal()
        }
        //sleep(1)
        queue.async {
            semaphore.wait(timeout: .distantFuture)
            
            Thread.sleep(forTimeInterval: 2)
            print("block 4")
            semaphore.signal()
        }
        
        print("Code kept running below")
    }
}
