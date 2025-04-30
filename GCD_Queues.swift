
GCD_Queues_summary

- There are three important types of Queues: Serial, Concurrent, Main
  1> Serial     : DispatchQueue(label: "")
                  Executes tasks one after an other in sequence

  2> Concurrent : DispatchQueue(label: "", attributes: .concurrent)
                  Executes tasks in parallel

  3> Main       : DispatchQueue.async.main
                  Always runs on the main thread


- Queues can be executed in two ways: Synchronously, Asynchronously
  1> Synchronously : .sync
                     Tasks executed on current/calling thread and blocks the thread untill completion

  2> Asynchronously: .async
                     This does not block the calling thread


 Default concurrent queue given by iOS
  let queue = DispatchQueue.global()

 User defined queue which is serial by default
  let queue = DispatchQueue(label: "") // By default this is Serial.

 User defined queue which we can make it concurrent by mentioning it in attributes
  let queue = DispatchQueue(label: "", attributes: .concurrent) // We are making it concurrent here.

-------------------------------------------------------------------------

//GCD_Queues

Below is a Swift explanation of different types of Grand Central Dispatch (GCD) queues, complete with example code and outputs. I’ll also explain when each should be used.

1. Serial Queue

A serial queue executes tasks one at a time in the order they are added.

Code:

import Foundation

let serialQueue = DispatchQueue(label: "com.example.serialQueue")

for i in 1...5 {
    serialQueue.async {
        print("Task \(i) started on Serial Queue")
        Thread.sleep(forTimeInterval: 1) // Simulates some work
        print("Task \(i) finished on Serial Queue")
    }
}

Output (tasks run one after another):

Task 1 started on Serial Queue
Task 1 finished on Serial Queue
Task 2 started on Serial Queue
Task 2 finished on Serial Queue
...

When to Use:
    •    Use when you want tasks to execute one at a time (e.g., writing to a file or updating a shared resource).


//------------------------------------------------------------------------------------------------------------------------------------------------


2. Concurrent Queue

A concurrent queue executes tasks in parallel, but the order of completion is not guaranteed.

Code:

let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)

for i in 1...5 {
    concurrentQueue.async {
        print("Task \(i) started on Concurrent Queue")
        Thread.sleep(forTimeInterval: 1) // Simulates some work
        print("Task \(i) finished on Concurrent Queue")
    }
}

Output (tasks run in parallel, order may vary):

Task 1 started on Concurrent Queue
Task 2 started on Concurrent Queue
Task 3 started on Concurrent Queue
Task 1 finished on Concurrent Queue
Task 4 started on Concurrent Queue
...

When to Use:
    •    Use when you want to perform multiple tasks concurrently, such as downloading multiple images or processing data in parallel.



//------------------------------------------------------------------------------------------------------------------------------------------------


3. Main Queue

The main queue is a serial queue used to update the UI. It always runs on the main thread.

Code:

DispatchQueue.main.async {
    print("Task on Main Queue (UI Update)")
}

Output:

Task on Main Queue (UI Update)

When to Use:
    •    Use for UI-related tasks (e.g., updating labels, buttons, or animations).

                    
 //------------------------------------------------------------------------------------------------------------------------------------------------

                    
4. Global Queue

The global queue is a shared concurrent queue provided by the system with different quality-of-service (QoS) levels.

Code:

let globalQueue = DispatchQueue.global(qos: .userInitiated)

for i in 1...3 {
    globalQueue.async {
        print("Task \(i) started on Global Queue")
        Thread.sleep(forTimeInterval: 1)
        print("Task \(i) finished on Global Queue")
    }
}

Output:

Task 1 started on Global Queue
Task 2 started on Global Queue
Task 3 started on Global Queue
Task 2 finished on Global Queue
...

When to Use:
    •    Use for tasks that are not UI-related and can be prioritized based on QoS (e.g., background processing, networking).
                    
//------------------------------------------------------------------------------------------------------------------------------------------------


5. Synchronous Execution

Tasks are executed on the current thread and block further execution until they complete.

Code:

let syncQueue = DispatchQueue(label: "com.example.syncQueue")

for i in 1...3 {
    syncQueue.sync { //This blocks the calling thread. serialQueueSynchronousExample as in playground
        print("Task \(i) started on Sync Queue")
        Thread.sleep(forTimeInterval: 1)
        print("Task \(i) finished on Sync Queue")
    }
}

Output (blocks the current thread):

Task 1 started on Sync Queue
Task 1 finished on Sync Queue
Task 2 started on Sync Queue
Task 2 finished on Sync Queue
...

When to Use:
    •    Use only when you need strict task completion order and must block further execution until the current task finishes.

//------------------------------------------------------------------------------------------------------------------------------------------------


6. Asynchronous Execution // This is nothing but Serial queue. Just terminology differnece.

Tasks are added to the queue and executed concurrently or serially depending on the queue type.

Code:

let asyncQueue = DispatchQueue(label: "com.example.asyncQueue") // Note: same as serial queue. because it is literally a serial queue

for i in 1...3 {
    asyncQueue.async { ////This does not block the calling thread . serialQueueAsynchronousExample as in playground
        print("Task \(i) started on Async Queue")
        Thread.sleep(forTimeInterval: 1)
        print("Task \(i) finished on Async Queue")
    }
}

Output (similar to serial queue, but non-blocking for caller):

Task 1 started on Async Queue
Task 1 finished on Async Queue
Task 2 started on Async Queue
...

When to Use:
    •    Use for non-blocking tasks where you don’t want to freeze the main thread or current execution.

//------------------------------------------------------------------------------------------------------------------------------------------------


7. Dispatch Groups

Used to synchronize multiple tasks and get notified when all tasks are complete.

//Look below for specific another example on this:

Code:

let group = DispatchGroup()
let groupQueue = DispatchQueue.global()

for i in 1...3 {
    group.enter()
    groupQueue.async {
        print("Task \(i) started")
        Thread.sleep(forTimeInterval: 1)
        print("Task \(i) finished")
        group.leave()
    }
}

group.notify(queue: DispatchQueue.main) {
    print("All tasks in the group are completed.")
}

Output:

Task 1 started
Task 2 started
Task 3 started
Task 1 finished
Task 2 finished
Task 3 finished
All tasks in the group are completed.

When to Use:
    •    Use when you need to aggregate results or ensure multiple tasks complete before proceeding (e.g., API batching, preloading data).


//------------------------------------------------------------------------------------------------------------------------------------------------



//Other Attributes on concurrent Queues:


When creating a concurrent queue in Swift using DispatchQueue, you can specify various attributes to configure its behavior. Attributes are used to define how the queue operates, such as whether it is concurrent, whether it supports specific quality-of-service (QoS) levels, and other options.

Attributes for Dispatch Queues

1. .concurrent
    •    Description: Specifies that the queue allows tasks to run concurrently (in parallel) rather than serially.
    •    Use Case: Use this attribute when you want multiple tasks to execute at the same time.

Example:

let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)

for i in 1...3 {
    concurrentQueue.async {
        print("Task \(i) started")
        Thread.sleep(forTimeInterval: 1)
        print("Task \(i) finished")
    }
}

    •    Output:

Task 1 started
Task 2 started
Task 3 started
Task 1 finished
Task 2 finished
Task 3 finished

2. .initiallyInactive
    •    Description: Specifies that the queue will not start executing tasks until explicitly activated using the activate() method.
    •    Use Case: Use this when you want to configure a queue but delay its execution until a specific point in your program.

Example:

let inactiveQueue = DispatchQueue(label: "com.example.inactiveQueue", attributes: [.concurrent, .initiallyInactive])

for i in 1...3 {
    inactiveQueue.async {
        print("Task \(i) started")
        Thread.sleep(forTimeInterval: 1)
        print("Task \(i) finished")
    }
}

// Activate the queue
print("Activating the queue...")
inactiveQueue.activate()

    •    Output:

Activating the queue...
Task 1 started
Task 2 started
Task 3 started
Task 1 finished
Task 2 finished
Task 3 finished

Combining Attributes

You can combine multiple attributes using an array-like syntax [.concurrent, .initiallyInactive] to configure multiple behaviors.

Example:

let customQueue = DispatchQueue(label: "com.example.customQueue", attributes: [.concurrent, .initiallyInactive])

customQueue.async {
    print("Task 1 started")
    Thread.sleep(forTimeInterval: 1)
    print("Task 1 finished")
}

// The queue is still inactive at this point
print("Queue is inactive...")

// Activate the queue
customQueue.activate()

    •    Output:

Queue is inactive...
Task 1 started
Task 1 finished

Important Notes
    1.    Default Attribute: If you do not specify any attributes, the queue is created as a serial queue.

let serialQueue = DispatchQueue(label: "com.example.serialQueue")


    2.    Quality of Service (QoS): Although not an “attribute,” you can specify a QoS class to influence the priority of tasks on the queue.

let qosQueue = DispatchQueue(label: "com.example.qosQueue", qos: .userInitiated)

    •    QoS levels include .userInteractive, .userInitiated, .default, .utility, .background, and .unspecified.

Key Takeaways
    •    .concurrent: Makes the queue concurrent, allowing tasks to run in parallel.
    •    .initiallyInactive: Creates an inactive queue that must be manually activated.
    •    Attributes can be combined for advanced configurations.
    •    Default behavior is a serial queue if no attributes are provided.



//----------------------------------------------------------------------
                                            
                                            


Example: Using DispatchGroup for Multiple Concurrent Network Calls

Imagine you have a scenario where you need to make multiple API calls in parallel (e.g., fetching user profiles, recent posts, and notifications). You want to wait until all these tasks are completed before updating the UI or proceeding further.

This is where DispatchGroup shines.

Code Example

import Foundation

let dispatchGroup = DispatchGroup()
let concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)

func fetchUserProfile(completion: @escaping () -> Void) {
    print("Fetching User Profile...")
    Thread.sleep(forTimeInterval: 2) // Simulating network delay
    print("User Profile fetched!")
    completion()
}

func fetchRecentPosts(completion: @escaping () -> Void) {
    print("Fetching Recent Posts...")
    Thread.sleep(forTimeInterval: 3) // Simulating network delay
    print("Recent Posts fetched!")
    completion()
}

func fetchNotifications(completion: @escaping () -> Void) {
    print("Fetching Notifications...")
    Thread.sleep(forTimeInterval: 1) // Simulating network delay
    print("Notifications fetched!")
    completion()
}

print("Starting API calls...")

// Add tasks to DispatchGroup
dispatchGroup.enter()
concurrentQueue.async {
    fetchUserProfile {
        dispatchGroup.leave()
    }
}

dispatchGroup.enter()
concurrentQueue.async {
    fetchRecentPosts {
        dispatchGroup.leave()
    }
}

dispatchGroup.enter()
concurrentQueue.async {
    fetchNotifications {
        dispatchGroup.leave()
    }
}

// Notify when all tasks are completed
dispatchGroup.notify(queue: DispatchQueue.main) {
    print("All API calls completed! Updating UI...")
}

print("This line is printed while tasks are still running...")

Output

Starting API calls...
This line is printed while tasks are still running...
Fetching User Profile...
Fetching Recent Posts...
Fetching Notifications...
Notifications fetched!
User Profile fetched!
Recent Posts fetched!
All API calls completed! Updating UI...

Explanation
    1.    dispatchGroup.enter() and dispatchGroup.leave():
    •    You call dispatchGroup.enter() before starting a task.
    •    When the task completes, you call dispatchGroup.leave(). This tells the DispatchGroup that a specific task has finished.
    2.    dispatchGroup.notify:
    •    Once all tasks have completed (i.e., the leave() count matches the enter() count), the notify closure is executed.
    •    Here, the UI is updated or any other dependent task is performed.
    3.    Parallel Execution:
    •    The tasks are dispatched onto a concurrent queue, so they run in parallel.
    •    The completion of the tasks does not block the main thread.
    4.    Non-blocking:
    •    The main thread continues executing immediately after the dispatchGroup.enter() calls. The notify block ensures that all work is complete before further dependent actions.

Real-world Use Cases for DispatchGroup
    •    Fetching data from multiple APIs before updating the UI.
    •    Running multiple computational tasks in parallel and aggregating results.
    •    Synchronizing database reads/writes or file operations.
    •    Preloading resources like images, videos, or configuration files.


------------------------------------------------------------------------------------------------------------------------------------
                            
                            
DispatchQueue.global is used when you want to execute tasks on a global, concurrent queue managed by the system. The global queue is optimal for performing tasks that can run concurrently without blocking the main thread. Each global queue is associated with a Quality of Service (QoS) level, which determines the priority and resources assigned to the task.

When to Use DispatchQueue.global
    •    Non-blocking Background Work: Use it for tasks like network requests, file I/O, or heavy computations that don’t require UI updates.
    •    Parallel Execution: Use it when multiple independent tasks need to execute concurrently.
    •    Control Over QoS: Use specific QoS levels to prioritize the execution of tasks based on their importance.

Quality of Service (QoS) Levels
    1.    User Interactive: High-priority tasks that affect UI responsiveness (e.g., animations, UI updates).
    2.    User Initiated: Tasks initiated by the user that require immediate results (e.g., fetching data after a button tap).
    3.    Utility: Medium-priority tasks that don’t require immediate results (e.g., downloading files, processing data).
    4.    Background: Low-priority tasks for non-user-facing work (e.g., syncing data, backups).
    5.    Default: A fallback QoS with no specific prioritization.

    Example: Using DispatchQueue.global with Different QoS Levels

                            import Foundation

                            func performTasksWithDifferentQoS() {
                                // High-priority task: User Interactive
                                DispatchQueue.global(qos: .userInteractive).async {
                                    print("User Interactive Task started")
                                    Thread.sleep(forTimeInterval: 1) // Simulating work
                                    print("User Interactive Task completed")
                                }

                                // Medium-high priority: User Initiated
                                DispatchQueue.global(qos: .userInitiated).async {
                                    print("User Initiated Task started")
                                    Thread.sleep(forTimeInterval: 2) // Simulating work
                                    print("User Initiated Task completed")
                                }

                                // Medium priority: Utility
                                DispatchQueue.global(qos: .utility).async {
                                    print("Utility Task started")
                                    Thread.sleep(forTimeInterval: 3) // Simulating work
                                    print("Utility Task completed")
                                }

                                // Low-priority task: Background
                                DispatchQueue.global(qos: .background).async {
                                    print("Background Task started")
                                    Thread.sleep(forTimeInterval: 4) // Simulating work
                                    print("Background Task completed")
                                }
                            }

                            // Call the function to see the execution
                            performTasksWithDifferentQoS()

                            Output Explanation
                            The system schedules tasks based on their QoS. In this example:
                            1.    User Interactive tasks are given the highest priority and executed as soon as possible.  2.    User Initiated tasks follow closely behind User Interactive.  3.    Utility and Background tasks are given progressively lower priority.
                            The output order may vary based on system resources, but higher-priority tasks (e.g., .userInteractive) are generally executed first.
                            When Not to Use
                                •    UI Updates: Avoid using DispatchQueue.global for UI updates. Use the main queue (DispatchQueue.main) instead.
                                •    Dependent Tasks: If tasks depend on each other, use serial queues or handle dependencies carefully to avoid race conditions.
