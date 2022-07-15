//
//  FithVC_GCD_Tests_2.swift
//  GCD
//
//  Created by test on 15.07.2022.
//

import UIKit

class FithVC_GCD_Tests_2: UIViewController {

    // workItem.perform() -> work item can be called straight away (without queue)
    // workItem.wait() -> will act like a wall, the code below won't execute until workItem finished executing
    // workItem.cancel() -> will stop execution of workItem, we can check if(!workItem.isCancelled){ workItem.cancel() }
    
    // FOR SOME REASON WORKITEM.CANCEL() DOES NOT WORK!
    
    var block: DispatchWorkItem?
    
    @IBAction func simple_test_Swiftbook(_ sender: Any) {
        simpleTestSwiftbook()
    }
    
    @IBAction func runTests_1(_ sender: Any) {
        runFirstTest()
    }
    @IBAction func stopBlock_1(_ sender: Any) {
        stopFirstBlock()
    }
    
    func simpleTestSwiftbook(){
        print("Simple test swiftbook")
        
        var workItem: DispatchWorkItem? = DispatchWorkItem {
            for i in 0...10{
                print(i)
                sleep(1)
            }
            print("Finished block work")
        }
        
        var queue = DispatchQueue(label: "Execute work item", qos: .background, attributes: .concurrent)
        
        queue.async(execute: workItem!)
        
        queue.async {
            var waitFor = 5
            print("started waiting \(waitFor) seconds")
            sleep(UInt32(waitFor))
            print("finished waiting \(waitFor) seconds")
            
            if(!workItem!.isCancelled){
                workItem!.cancel()
                print("workItem should be cancelled")
                print("workItemCancelled: \(workItem!.isCancelled)")
                workItem = nil
            }
        }
        
        print("Code kept running 1")
        
        workItem!.notify(queue: DispatchQueue.main) {
            print("WorkItem finished, pretend to execute some work")
        }
        
        print("Going to freeze until workItem finished it's job")
        
        workItem!.wait()
        
        print("Code kept running 2")
        
    }
    
    func runFirstTest(){
        print("Run first test")
        stopFirstBlock(useLogs: true)
        
        block =  DispatchWorkItem {
            for i in 0...10{
                print(i)
                sleep(1)
            }
            print("Finished block work")
        }
        
        DispatchQueue.global(qos: .utility).async(execute: block!)
        
        print("Code kept running below")
    }
    
    func stopFirstBlock(useLogs: Bool = true){
        guard var block = block else {
            //if(useLogs){
                print("No block to stop")
            //}
            return
            
        }
        
        block.cancel()
        print("Block was cancelled")
    }
    

}
