
Here’s an easier explanation of each SOLID principle in simple language with practical examples in Swift:

1. Single Responsibility Principle (SRP)

What it means:
Each class or piece of code should do only one job. If you need to change something, it should only affect one part of the code.

Example:
Imagine you have a Car. The engine should only handle driving, and the radio should only play music. They shouldn’t interfere with each other.

Swift Example:

// BAD: This class does two jobs: handling users and sending emails
class UserManager {
    func saveUser() {
        print("User saved")
    }

    func sendEmail() {
        print("Email sent")
    }
}

// GOOD: Separate the responsibilities into different classes
class UserRepository {
    func saveUser() {
        print("User saved")
    }
}

class EmailService {
    func sendEmail() {
        print("Email sent")
    }
}


//----------------------------------------------------------------



2. Open/Closed Principle (OCP)

What it means:
Your code should be open for adding new features, but closed for changing existing code. This avoids breaking things when adding something new.

Example:
If you add new toppings to a pizza menu, you shouldn’t have to change the entire pizza-making process. Just add the new toppings list.

Swift Example:

// BAD: Adding new payment methods requires changing the existing code
class PaymentProcessor {
    func processPayment(type: String) {
        if type == "Card" {
            print("Processing card payment")
        } else if type == "Cash" {
            print("Processing cash payment")
        }
    }
}

// GOOD: Add new payment methods without changing existing code
protocol Payment {
    func process()
}

class CardPayment: Payment {
    func process() {
        print("Processing card payment")
    }
}

class CashPayment: Payment {
    func process() {
        print("Processing cash payment")
    }
}

class PaymentProcessor {
    func process(payment: Payment) {
        payment.process()
    }
}

//--------------------------------------------------------------------------------------------------------------

3. Liskov Substitution Principle (LSP)

What it means:
You should be able to use a subclass wherever the parent class is expected without breaking anything.

Example:
A square is a rectangle, but if you treat them the same, the square’s special behavior (equal sides) might cause problems. Instead, treat them as separate.

Swift Example: ( Note another example is given below )

// BAD: Square modifies Rectangle’s behavior, causing issues

class Rectangle {
    var width: Double
    var height: Double
    
    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
    
    func setWidth(_ width: Double) {
        self.width = width
    }
    
    func setHeight(_ height: Double) {
        self.height = height
    }
    
    func area() -> Double {
        return width * height
    }
}

// A Square subclass inherits from Rectangle
class Square: Rectangle {
    override func setWidth(_ width: Double) {
        super.setWidth(width)
        super.setHeight(width) // Maintain square property
    }
    
    override func setHeight(_ height: Double) {
        super.setHeight(height)
        super.setWidth(height) // Maintain square property
    }
}

// Function to test
func printArea(of rectangle: Rectangle) {
    rectangle.setWidth(5)
    rectangle.setHeight(10)
    print("Area: \(rectangle.area())")
}

// Testing
let rectangle = Rectangle(width: 5, height: 10)
printArea(of: rectangle) // Area: 50

let square = Square(width: 5, height: 5)
printArea(of: square) // Area: 100? This is incorrect!


//Although its a stupid example, remember developers might end up in this situation:
//1 . a. Misusing Inheritance to Reuse Code
//2 . b. Overriding Behavior Instead of Designing Separately
//3 . c. Assumption That “It Just Works”


// Another example

Liskov Substitution Principle (LSP)
subclasses should behave in such a way that they can seamlessly replace their parent class without causing errors.

The Wrong Way (Violation of LSP)
Let’s take the example of birds. Imagine a base class Bird that assumes all birds can fly. However, some birds like Kiwis cannot fly, but this assumption forces them to implement the fly method.

class Bird {
    func fly() {
        print("I am flying!")
    }
}

class Sparrow: Bird {
    override func fly() {
        print("Sparrow flaps its wings and flies.")
    }
}

class Kiwi: Bird {
    override func fly() {
        // Kiwi cannot fly, so we throw an error.
        print("Kiwis cannot fly!")
    }
}

// Using the base class
func letBirdFly(_ bird: Bird) {
    bird.fly()
}

// Testing
let sparrow = Sparrow()
letBirdFly(sparrow) // Works as expected: "Sparrow flaps its wings and flies."

let kiwi = Kiwi()
letBirdFly(kiwi) // Prints: "Kiwis cannot fly!" but conceptually, this is incorrect.

Problems:
    1.    The Kiwi class is forced to implement the fly method even though it cannot fly. This creates confusion for anyone using the Bird type.
    2.    The behavior of the program becomes unpredictable. For example, if you call fly on a Kiwi, it may print an error message or fail entirely.
    3.    Violates the principle as the Kiwi cannot truly replace a Bird without breaking functionality.

The Correct Way

We should redesign the hierarchy so that the fly behavior is decoupled from the Bird base class. Not all birds can fly, so we create an additional abstraction for flying behavior.

// Base class for all birds
class Bird {
    func eat() {
        print("I am eating!")
    }
}

// Separate protocol for flying behavior
protocol Flyable {
    func fly()
}

// A Sparrow is a bird that can fly
class Sparrow: Bird, Flyable {
    func fly() {
        print("Sparrow flaps its wings and flies.")
    }
}

// A Kiwi is a bird that cannot fly
class Kiwi: Bird {
    // No need to implement `fly` because Kiwi cannot fly
}

// Function to handle only Flyable birds
func letBirdFly(_ bird: Flyable) {
    bird.fly()
}

// Testing
let sparrow = Sparrow()
letBirdFly(sparrow) // Works as expected: "Sparrow flaps its wings and flies."

let kiwi = Kiwi()
// Cannot pass `kiwi` to `letBirdFly` because `Kiwi` does not conform to `Flyable`

Benefits:
    1.    Clear Responsibilities: Only birds that can fly implement the Flyable protocol, eliminating confusion.
    2.    Error Prevention: You cannot accidentally call fly on a Kiwi because it does not conform to Flyable.
    3.    LSP Compliance: Subtypes like Sparrow and Kiwi can replace Bird in contexts where they are used correctly, without breaking the system.

Key Takeaway:
    •    When designing inheritance hierarchies, avoid forcing all subclasses to support behavior they cannot fulfill.
    •    Use protocols or mixins to segregate optional behaviors (like Flyable), ensuring subtypes comply with the expectations of the parent class.




//Another example:

Let’s explore Liskov Substitution Principle (LSP) with another real-world example involving vehicles.

Scenario: Vehicle Example

We want to model a system where different types of vehicles are represented, and a base class Vehicle defines shared behavior. Let’s see how LSP violations can occur and how to fix them.

The Wrong Way (Violation of LSP)

Let’s say we have a Vehicle class that includes a startEngine method because most vehicles have engines. Then, we create a subclass for Bicycle, which doesn’t have an engine.

// Base class for vehicles
class Vehicle {
    func startEngine() {
        print("Engine started!")
    }

    func move() {
        print("Vehicle is moving!")
    }
}

// Subclass for cars
class Car: Vehicle {
    override func startEngine() {
        print("Car engine started!")
    }
}

// Subclass for bicycles (which do not have engines)
class Bicycle: Vehicle {
    override func startEngine() {
        // Force bicycles to implement this method, even though it doesn't make sense
        print("Bicycles do not have engines!")
    }
}

// Function to test
func startVehicle(_ vehicle: Vehicle) {
    vehicle.startEngine()
    vehicle.move()
}

// Testing
let car = Car()
startVehicle(car) // Output: "Car engine started!" and "Vehicle is moving!"

let bicycle = Bicycle()
startVehicle(bicycle) // Output: "Bicycles do not have engines!" and "Vehicle is moving!"

Why This Violates LSP
    1.    Behavioral Mismatch:
    •    The Bicycle class overrides startEngine to provide an implementation, but it doesn’t make sense conceptually because bicycles don’t have engines.
    •    The base class Vehicle assumes all vehicles have engines, which isn’t true for bicycles.
    2.    Unexpected Behavior:
    •    The function startVehicle(_:) assumes every vehicle can start an engine, which leads to misleading behavior when a bicycle is passed.
    3.    Fragility:
    •    If the system expands to include more engine-less vehicles (e.g., skateboards), you’ll have to continue overriding startEngine with meaningless implementations, making the code harder to maintain.

The Right Way

Instead of assuming all vehicles have engines, we can separate the engine-related functionality into a protocol. This way, only vehicles with engines conform to the EngineOperable protocol.

Solution Using Protocols

// Base class for all vehicles
class Vehicle {
    func move() {
        print("Vehicle is moving!")
    }
}

// Protocol for vehicles with engines
protocol EngineOperable {
    func startEngine()
}

// Subclass for cars
class Car: Vehicle, EngineOperable {
    func startEngine() {
        print("Car engine started!")
    }
}

// Subclass for bicycles
class Bicycle: Vehicle {
    // No need to implement startEngine because bicycles don’t have engines
}

// Function to test
func startEngineForVehicle(_ vehicle: EngineOperable) {
    vehicle.startEngine()
}

// Testing
let car = Car()
startEngineForVehicle(car) // Output: "Car engine started!"

let bicycle = Bicycle()
// startEngineForVehicle(bicycle) // Compiler error: Bicycle does not conform to EngineOperable

// General movement functionality still works
let someVehicle: Vehicle = Bicycle()
someVehicle.move() // Output: "Vehicle is moving!"

Why This Approach is Correct
    1.    LSP Compliance:
    •    Car and Bicycle are both subtypes of Vehicle and can replace Vehicle wherever movement is concerned. However, only Car conforms to EngineOperable because it has an engine.
    •    This avoids forcing irrelevant behavior on Bicycle.
    2.    Clear Responsibilities:
    •    The startEngine method is only relevant for vehicles with engines. By segregating this behavior into a protocol, the design becomes more logical and modular.
    3.    Scalability:
    •    Adding new types of vehicles (e.g., Skateboard, Motorcycle) is easier and avoids redundant overrides or meaningless implementations.

Key Takeaways
    •    Avoid forcing all subclasses to support behavior that isn’t applicable to them.
    •    Use protocols or composition to model optional behaviors (e.g., engine-related functionality).
    •    Always ensure that subclasses can seamlessly replace their parent class without breaking expectations or introducing inconsistencies.
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
//----------------------------------------------------------------
                                                        
                                                        

4. Interface Segregation Principle (ISP)

What it means:
Don’t force a class to implement methods it doesn’t need. Break large protocols into smaller, more focused ones.

Example:
A basic printer shouldn’t need to know how to send a fax. Only give it the features it needs.

Swift Example:

// BAD: One big protocol forces unnecessary methods on every class
protocol AllInOnePrinter {
    func printDocument()
    func scanDocument()
    func faxDocument()
}

class BasicPrinter: AllInOnePrinter {
    func printDocument() {
        print("Printing document")
    }
    
    func scanDocument() {
        // Basic printer can't scan
    }
    
    func faxDocument() {
        // Basic printer can't fax
    }
}

// GOOD: Separate protocols for specific tasks
protocol Printable {
    func printDocument()
}

protocol Scannable {
    func scanDocument()
}

protocol Faxable {
    func faxDocument()
}

class BasicPrinter: Printable {
    func printDocument() {
        print("Printing document")
    }
}
//-------------------------------------------------------------------------

5. Dependency Inversion Principle (DIP)

What it means:
High-level code (important parts of your app) shouldn’t depend directly on low-level code (details). Both should rely on abstractions (protocols or interfaces).

Example:
A remote control should work with any type of TV, not just one specific brand.

Swift Example:

// BAD: High-level code depends on a specific low-level class
class MySQLDatabase {
    func fetchData() -> String {
        return "Data from MySQL"
    }
}

class DataFetcher {
    let database = MySQLDatabase()

    func getData() -> String {
        return database.fetchData()
    }
}

// GOOD: High-level code depends on a protocol (abstraction)
protocol Database {
    func fetchData() -> String
}

class MySQLDatabase: Database {
    func fetchData() -> String {
        return "Data from MySQL"
    }
}

class PostgreSQLDatabase: Database {
    func fetchData() -> String {
        return "Data from PostgreSQL"
    }
}

class DataFetcher {
    let database: Database

    init(database: Database) {
        self.database = database
    }

    func getData() -> String {
        return database.fetchData()
    }
}

// Usage
let database = MySQLDatabase()
let dataFetcher = DataFetcher(database: database)
print(dataFetcher.getData())

Summary in Plain Words
	1.	Single Responsibility: Each class should do one thing only.
Example: A car’s engine shouldn’t handle the radio.
	2.	Open/Closed: Add new features by extending, not changing existing code.
Example: Add new pizza toppings without rewriting how to make pizza.
	3.	Liskov Substitution: Subclasses should be usable in place of their parent class without breaking things.
Example: A square and a rectangle should behave as expected.
	4.	Interface Segregation: Don’t force a class to implement methods it doesn’t need.
Example: A basic printer shouldn’t need faxing abilities.
	5.	Dependency Inversion: High-level code should depend on abstract concepts (protocols), not specific details.
Example: A remote control should work with any brand of TV.

By following these principles, your Swift code will be cleaner, easier to maintain, and less error-prone.


Another example:

Dependency Inversion Principle (DIP)

The Dependency Inversion Principle (DIP) is the “D” in SOLID principles. It states:

    High-level modules should not depend on low-level modules. Both should depend on abstractions.

In simpler terms:
    •    Code should depend on interfaces or abstract classes, not on concrete implementations.
    •    This decouples the system and makes it more flexible, testable, and extendable.

Why Dependency Inversion?

In traditional design, high-level modules (e.g., business logic) directly depend on low-level modules (e.g., specific APIs or data layers). This creates a tightly coupled system where changes to low-level modules ripple through the entire system.

Example Problem:
Imagine an application where the business logic depends directly on a database implementation. If you later decide to switch the database (e.g., from MySQL to MongoDB), you need to rewrite parts of the business logic to accommodate the new database.

Key Goals of Dependency Inversion:
    1.    Decoupling: The high-level module should not need to know how the low-level module is implemented.
    2.    Flexibility: Swapping implementations (e.g., changing the database) should be easy and not require changes to high-level modules.
    3.    Testability: Mocking dependencies for testing becomes easier when relying on abstractions.

Core Components:
    1.    High-Level Module: The business logic or core part of your application.
    2.    Low-Level Module: The implementation details like database interaction, network requests, or file handling.
    3.    Abstraction: An interface or abstract class that defines the contract between the high-level and low-level modules.

The Wrong Way (Violation of DIP)

Here’s a classic example: A PaymentProcessor depends directly on a PayPalService.

// Low-level module
class PayPalService {
    func processPayment(amount: Double) {
        print("Processing payment of \(amount) through PayPal.")
    }
}

// High-level module
class PaymentProcessor {
    private let payPalService = PayPalService() // Direct dependency

    func makePayment(amount: Double) {
        payPalService.processPayment(amount: amount)
    }
}

// Usage
let processor = PaymentProcessor()
processor.makePayment(amount: 100.0)

Issues:
    1.    Tight Coupling: The PaymentProcessor is tightly coupled to PayPalService. If you want to use another payment gateway (e.g., Stripe), you must modify PaymentProcessor.
    2.    Low Flexibility: Adding new payment services requires modifying the PaymentProcessor class, violating the Open/Closed Principle.
    3.    Hard to Test: You can’t easily mock PayPalService for unit tests without a lot of effort.

The Right Way (DIP-Compliant Design)

We can fix this by introducing an abstraction (PaymentService) that both high-level (PaymentProcessor) and low-level (PayPalService) modules depend on.

// Abstraction
protocol PaymentService {
    func processPayment(amount: Double)
}

// Low-level module (implementation 1)
class PayPalService: PaymentService {
    func processPayment(amount: Double) {
        print("Processing payment of \(amount) through PayPal.")
    }
}

// Low-level module (implementation 2)
class StripeService: PaymentService {
    func processPayment(amount: Double) {
        print("Processing payment of \(amount) through Stripe.")
    }
}

// High-level module
class PaymentProcessor {
    private let paymentService: PaymentService

    // Dependency Injection: Inject the dependency via initializer
    init(paymentService: PaymentService) {
        self.paymentService = paymentService
    }

    func makePayment(amount: Double) {
        paymentService.processPayment(amount: amount)
    }
}

// Usage
let payPalProcessor = PaymentProcessor(paymentService: PayPalService())
payPalProcessor.makePayment(amount: 100.0) // "Processing payment of 100.0 through PayPal."

let stripeProcessor = PaymentProcessor(paymentService: StripeService())
stripeProcessor.makePayment(amount: 200.0) // "Processing payment of 200.0 through Stripe."

Benefits:
    1.    Loose Coupling: PaymentProcessor is not tied to a specific implementation of PaymentService. It works with any class that conforms to the PaymentService protocol.
    2.    Flexibility: You can easily add or switch to a new payment service (e.g., Razorpay) without modifying PaymentProcessor.
    3.    Testability: You can create mock implementations of PaymentService for unit testing.

Dependency Injection (DI) to Achieve DIP

Dependency Injection (DI) is a common pattern to implement the Dependency Inversion Principle. Instead of a high-level module creating its dependencies, they are injected into it. There are three common ways to perform DI:
    1.    Constructor Injection: Dependencies are passed into the class via its initializer (used in the example above).
    2.    Setter Injection: Dependencies are set via a setter method.
    3.    Interface Injection: The dependency is passed via an interface method.

Advantages of Dependency Inversion
    1.    Scalability: Easier to extend the system by adding new implementations without modifying existing code.
    2.    Maintainability: Changes in one module don’t cascade through the system because the code is decoupled.
    3.    Testability: Abstractions enable mocking and easier unit testing.
    4.    Flexibility: Supports replacing low-level modules (e.g., swapping libraries or frameworks) without affecting high-level logic.

When to Use Dependency Inversion
    1.    Large Applications:
    •    DIP is especially useful in large applications where different parts of the system (UI, database, APIs) evolve independently.
    2.    Swappable Implementations:
    •    When you need the flexibility to switch or replace modules without modifying the core logic (e.g., switching payment gateways, logging frameworks, or storage mechanisms).
    3.    Testing:
    •    To make components more testable by mocking or stubbing dependencies.

Real-World Examples of Dependency Inversion
    1.    iOS Development:
    •    ViewModels in MVVM depend on abstractions for services (e.g., API service, data storage) rather than concrete implementations.
    •    This enables swapping out the networking layer for testing or mocking.

protocol APIService {
    func fetchData() -> String
}

class RealAPIService: APIService {
    func fetchData() -> String {
        return "Data from real API"
    }
}

class MockAPIService: APIService {
    func fetchData() -> String {
        return "Mock data for testing"
    }
}

class ViewModel {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getData() -> String {
        return apiService.fetchData()
    }
}

let realViewModel = ViewModel(apiService: RealAPIService())
print(realViewModel.getData()) // Output: "Data from real API"

let mockViewModel = ViewModel(apiService: MockAPIService())
print(mockViewModel.getData()) // Output: "Mock data for testing"


    2.    Frameworks:
    •    Many frameworks (e.g., Spring in Java, Swinject in Swift) use Inversion of Control (IoC) to manage dependencies. Instead of classes instantiating their own dependencies, the framework provides and injects them.

Key Takeaways
    •    Dependency Inversion Principle promotes flexible, maintainable, and testable code.
    •    It shifts the dependency from concrete implementations to abstractions (protocols/interfaces).
    •    Dependency Injection (DI) is a pattern to achieve DIP by injecting required dependencies instead of hardcoding them.
    •    Properly applying DIP makes your code scalable and adaptable to change.




