//
//  TaskQueue.swift
//  SportsTracer
//
//  Created by Li, Jin Hui on 2020/8/3.
//  Copyright © 2020 HalfRoad Software Inc. All rights reserved.
//

import UIKit

public struct TaskQueue<T> {
        
    fileprivate var array = [T] ()
    
    init() {
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func enqueque (_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeque () -> T? {
        
        if isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    public mutating func purge () {
        
        array.removeAll()
    }
    
    public var front: T? {
        return array.first
    }
    
    public var tail: T? {
        return array.last
    }
}
