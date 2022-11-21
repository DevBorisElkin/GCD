//
//  FirstNsOperationViewController.swift
//  GCD
//
//  Created by test on 21.11.2022.
//

import UIKit

class FirstNsOperationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    var concurrentOperation: BlockOperation?

    @IBAction func firstTestAction(_ sender: Any) {
        print("firstTestAction")
        
        // 1)
        //print(Thread.current)
//        let firstFunc = {
//            print("Start")
//            print(Thread.current)
//            print("Finish")
//        }
//
//        let queue = OperationQueue()
//        queue.addOperation(firstFunc)
        
        print(Thread.current)
        var result: String?
        let concurrentOperation = BlockOperation {
            result = "I'm Boris - The Developer"
            print("In operation body: \(Thread.current)")
            sleep(5)
            
            if let currentOperation = self.concurrentOperation, currentOperation.isCancelled {
                print("Operation is cancelled, returning")
                return
            }
            print("concurrentOperation finished")
        }
        self.concurrentOperation = concurrentOperation
        
//        concurrentOperation.start()
//        print(result!)
        
        let queue = OperationQueue()
        concurrentOperation.completionBlock = {
            if concurrentOperation.isCancelled {
                print("operation is cancelled so completion won't be executed")
                return
            }
            print("in operation completion: \(Thread.current)")
            print("concurrentOperationHasFinished")
            print(result)
            DispatchQueue.main.async {
                print("in operation completion in dispatch.main.async: \(Thread.current)")
                self.view.backgroundColor = UIColor.random()
            }
        }
        queue.addOperation(concurrentOperation)
        
        print(result)
        
        
        // we can add operations to operationQueue like this
//        queue.addOperation {
//            // do somthing
//        }
    }
    
    @IBAction func cancelOperation(_ sender: Any) {
        print("cancelOperation")
        concurrentOperation?.cancel()
    }
    
    @IBAction func interestingTests(_ sender: Any) {
        let myThread = MyThread()
        myThread.start()
        
        let myOperation = MyOperation()
        myOperation.start()
    }
    
    // _________
    
    var operationQueue = OperationQueue()
    
    @IBAction func runMultipleTasksOnQueue(_ sender: Any) {
        print("runMultipleTasksOnQueue")
        
        operationQueue.addOperation {
            print("first operation started")
            sleep(2)
            print("first operation finished")
        }
        
        operationQueue.addOperation {
            print("second operation started")
            sleep(12)
            print("second operation finished")
        }
        
        operationQueue.addOperation {
            print("third operation started")
            sleep(5)
            print("third operation finished")
        }
        // 15 total delay
        
        operationQueue.addBarrierBlock {
            print("barrier block started")
            sleep(3)
            print("barrier block finished")
        }
        // 18 total
        
        operationQueue.addOperation {
            print("fourth operation started after barrier block")
            sleep(5)
            print("fourth operation finished")
        }
        
        operationQueue.addOperation {
            print("fifth operation started after barrier block")
            sleep(5)
            print("fifth operation finished")
        }
        // 23 total
        
    }
    
    @IBAction func cancelMultipleTasksOnQueue(_ sender: Any) {
        print("operationQueue.cancelMultipleTasksOnQueue")
        operationQueue.cancelAllOperations()
    }
    
    @IBAction func setConcurrentOperationsCountTo1(_ sender: Any) {
        print("setConcurrentOperationsCountTo1")
        operationQueue.maxConcurrentOperationCount = 1
    }
    @IBAction func setConcurrentOperationsCountTo9(_ sender: Any) {
        print("setConcurrentOperationsCountTo9")
        operationQueue.maxConcurrentOperationCount = 9
    }
    
    @IBAction func increaseConcurrentCount(_ sender: Any) {
        print("setConcurrentOperationsCountTo \(operationQueue.maxConcurrentOperationCount + 1)")
        operationQueue.maxConcurrentOperationCount += 1
    }
    
    @IBAction func decreaseConcurrentCount(_ sender: Any) {
        print("setConcurrentOperationsCountTo \(operationQueue.maxConcurrentOperationCount - 1)")
        operationQueue.maxConcurrentOperationCount -= 1
    }
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
    @IBAction func addArrayOfOperations(_ sender: Any) {
        print("addArrayOfOperations")
        launchArrayOfOperations()
    }
    
    @IBAction func addArrayOfOperationsNonMainThread(_ sender: Any) {
        print("addArrayOfOperationsNonMainThread")
        let alternativeOperationQueue = OperationQueue()
        alternativeOperationQueue.maxConcurrentOperationCount = 1
        alternativeOperationQueue.qualityOfService = .userInteractive
        alternativeOperationQueue.addOperation {
            self.launchArrayOfOperations()
        }
        
    }
    
    func launchArrayOfOperations() {
        var operationsArray: [Operation] = []
        
        operationsArray.append(BlockOperation(block: { [weak self] in
            sleep(3)
            DispatchQueue.main.async {
                self?.view1.backgroundColor = UIColor.random()
            }
            print("n 1 operation finished")
        }))
        operationsArray.append(BlockOperation(block: { [weak self] in
            sleep(8)
            DispatchQueue.main.async {
                self?.view2.backgroundColor = UIColor.random()
            }
            print("n 2 operation finished")
        }))
        operationsArray.append(BlockOperation(block: { [weak self] in
            sleep(6)
            DispatchQueue.main.async {
                self?.view3.backgroundColor = UIColor.random()
            }
            print("n 3 operation finished")
        }))
        operationsArray.append(BlockOperation(block: { [weak self] in
            sleep(11)
            DispatchQueue.main.async {
                self?.view4.backgroundColor = UIColor.random()
            }
            print("n 4 operation finished")
        }))
        
        operationQueue.addOperations(operationsArray, waitUntilFinished: false)
        print("Code kept going")
        
        operationQueue.addOperation(BlockOperation(block: { [weak self] in
            print("5th operation started, progress: \(self?.operationQueue.progress)")
            sleep(3)
            DispatchQueue.main.async {
                self?.view5.backgroundColor = UIColor.random()
            }
            print("5th operation finished, progress: \(self?.operationQueue.progress)")
        }))
    }
    
}

class MyThread: Thread {
    override func main() {
        print("main of thread overriden, \(Thread.current)")
    }
}

class MyOperation: Operation {
    override func main() {
        print("operation main() overriden, \(Thread.current)")
    }
}
