//
//  FithVC_GCD_Tests_2.swift
//  GCD
//
//  Created by test on 15.07.2022.
//

import UIKit

class FithVC_GCD_Tests_2: UIViewController {

    @IBOutlet var semaphoreExample: SemaphoreExample!
    
    
    // workItem.perform() -> work item can be called straight away (without queue)
    // workItem.wait() -> will act like a wall, the code below won't execute until workItem finished executing
    // workItem.cancel() -> will stop execution of workItem, we can check if(!workItem.isCancelled){ workItem.cancel() }
    
    // FOR SOME REASON WORKITEM.CANCEL() DOES NOT WORK!
    // https://medium.com/@yostane/swift-sweet-bits-the-dispatch-framework-ios-10-e34451d59a86
    // .cancel() will cancel something that has not been invoked, but not something that is running, we need to make a workaround and force the code that's being executed to stop working
    // https://overcoder.net/q/835089/dispatchworkitem-%D0%BD%D0%B5-%D0%B7%D0%B0%D0%B2%D0%B5%D1%80%D1%88%D0%B0%D0%B5%D1%82-%D1%84%D1%83%D0%BD%D0%BA%D1%86%D0%B8%D1%8E-%D0%BF%D1%80%D0%B8-%D0%B2%D1%8B%D0%B7%D0%BE%D0%B2%D0%B5-cancel
    
    /*
     A dispatch work item has a cancel flag. If it is cancelled before running, the dispatch queue wont execute it and will skip it. If it is cancelled during its execution, the cancel property return True. In that case, we can abort the execution
     */
    
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
    
    
    
    @IBAction func runSemaphoreExample(_ sender: Any) {
        semaphoreExample.startExample()
    }
    
}
