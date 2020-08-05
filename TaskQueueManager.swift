//
//  TaskQueueManager.swift
//  SportsTracer
//
//  Created by Li, Jin Hui on 2020/8/3.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

/*
 
 Usage:
 
 let taskQueueManager = TaskQueueManager()
 
 taskQueueManager.schedule { (id, callback) in
 
    // Some time consumption execution
 
    callback(id)
 }
 
 taskQueueManager.start {
 
    // callback when all tasks done.
 }
*/

class TaskQueueManager: NSObject {

    enum TaskStatuses {
        case idle
        case dispatched
        case running
        case paused
        case cancelled
        case completed
    }

    class Task: NSObject {
        
        fileprivate var identifier: Int = 0
        var block: (_ identifier: Int, _ callback: @escaping (_ identifier: Int) -> Void) -> Void
        var priority: Int = 0
        fileprivate var status: TaskStatuses = .idle
        fileprivate let time = Date ()
        
        convenience init (_ identifier: Int, _ block: @escaping (_ identifier: Int, _ callback: @escaping (_ identifier: Int) -> Void) -> Void) {
            
            self.init (identifier, block, 0)
        }
        
        init (_ identifier: Int, _ block: @escaping ((_ identifier: Int, _ callback: @escaping (_ identifier: Int) -> Void) -> Void), _ priority: Int) {
            
            self.identifier = identifier
            self.block = block
            self.priority = priority
            self.status = .idle
        }
    }

    class TaskQueueManager: NSObject {
        
        static let shared = TaskQueueManager()
        private var queue = TaskQueue<Task>()
        private var runningTask: Task? = nil
        
        func schedule (block: @escaping (_ identifier: Int, _ callback: @escaping (_ identifier: Int) -> Void) -> Void) {
            
            var identifier = 0
            if let tail = queue.tail {
                identifier = tail.identifier + 1
            }
            
            let task = Task (identifier, block)
            
            queue.enqueque(task)
        }
        
        func start (with completionHandler: (() -> Void)?) {
            
            if let task = queue.front, task.status == TaskStatuses.idle {
                
                let callback: (_ identifier: Int) -> Void = {_ in
                    
                    if let task = self.queue.dequeque() {
                        self.runningTask = nil
                        print("Task number \(task.identifier)/\(self.queue.count) is completed and dequequed.")
                    }
                    
                    self.start(with: completionHandler)
                }
                
                task.block(task.identifier, callback)
                self.runningTask = task
                
            } else {
                if let handler = completionHandler {
                    handler()
                }
            }
        }
        
        func purge() {
            
            if !queue.isEmpty {
                queue.purge()
            }
        }
    }
}
