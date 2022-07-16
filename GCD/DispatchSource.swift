//
//  DispatchSource.swift
//  GCD
//
//  Created by test on 16.07.2022.
//

import Foundation

func launchTestTimer(){
    
    print("launchTestTimer")
    
    var queue = DispatchQueue(label: "Some queue", attributes: .concurrent)
    
    var timer = DispatchSource.makeTimerSource(queue: queue)
    
    timer.schedule(deadline: .now(), repeating: .seconds(2), leeway: .milliseconds(200))
    timer.setEventHandler {
        print("Hello, World!")
    }
    
    timer.setCancelHandler {
        print("Timer is cancelled")
    }
    
    timer.resume()
}
