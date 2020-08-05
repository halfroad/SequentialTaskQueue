# SequentialTaskQueue
Executing queued tasks one by one

 Usage:
 
 let taskQueueManager = TaskQueueManager()
 
 taskQueueManager.schedule { (id, callback) in
 
    // Some time consumption execution
 
    callback(id)
 }
 
 taskQueueManager.start {
 
    // callback when all tasks done.
 }
