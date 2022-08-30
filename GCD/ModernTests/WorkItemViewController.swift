//
//  WorkItemViewController.swift
//  GCD
//
//  Created by test on 30.08.2022.
//

import UIKit

class WorkItemViewController: UIViewController {

    private let queue = DispatchQueue(label: "DispatchWorkItemTest_1")
    private let concurrentQueue = DispatchQueue(label: "DispatchWorkItemTest_1", attributes: .concurrent)
    
    var item: DispatchWorkItem?
    
    @IBOutlet weak var picture: UIImageView!
    
    @IBAction func tests1pressed(_ sender: Any) {
        // Это сериал(последовательная очередь)
        queue.async { [weak self] in
            print("First block of code, sleeping 4 sec")
            sleep(4)
            print("sleep ended, cancelling work item")
            
            // удаляет dispatchWorkItem из очереди
            // можно отменить (удалить из очереди) только до старта выполнения
            self?.item?.cancel()
        }
        
        self.item = DispatchWorkItem {
            print("item block execution started, sleeping 10 sec and doing some work")
            sleep(10)
            print("DispatchWorkItem sleep ended, work ended")
        }
        
        if let item = item {
            print("launching work item")
            queue.async(execute: item)
        }
    }
    
    // we can stop work item only before it has been launched
    @IBAction func tests2pressed(_ sender: Any) {
        concurrentQueue.async { [weak self] in
            print("First block of code, sleeping 4 sec")
            sleep(4)
            print("sleep ended, cancelling work item")
            self?.item?.cancel()
        }
        
        self.item = DispatchWorkItem {
            print("item block execution started, sleeping 10 sec and doing some work")
            sleep(10)
            print("DispatchWorkItem sleep ended, work ended")
        }
        
        if let item = item {
            print("launching work item")
            concurrentQueue.async(execute: item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}
