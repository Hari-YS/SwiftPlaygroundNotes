
Object oriented programming

- OOP concepts are the backbone of Swift, enabling clean code organization, modularity, and reusability.

- Basic concepts of OOPs in SWIFTY way:
    Classes
    Objects
    Properties
    Methods
    Access Control
    Encapsulation
    Abstraction
    Inheritance
    Method Overriding
    Method Overloading
    Polymorphism

// MARK: - Class
Class is like a blueprint, it defines the data and behavior of a type.


// MARK: - Object
An object is a specific instance of a class; it contains real values instead of variables.
    Eg — Think of Person as a group or class. Every Person be it, men or women have properties and attributes which are common to both. An object is anything that you see which comes from a particular class. Eg — Dog, Cat, Pen, Pencil, etc, everything is an object. From our Person example, men and women are examples of objects which belong to same class i.e Person.


// MARK: - Properties
Technically, properties of a class are common attributes of that class that can be shared across each object which is derived from it. They are the attributes of a class that describe the state of its objects.



// MARK: - Methods/Functions
Methods or Functions - are the behavior of the objects of a class. Let us say a person can walk, sing, play, etc irrespective of any object(Man/Woman). These all can be said to be methods/functions of the class.


class Person_ {
    //Your Personal attributes and abilities can be defined here.
}

let man = Person_() //we created an object of Person

class Person {
    var age: Int! //These are some of the properties of Person class
    var gender: String!
    var color: String!
    var maritialStatus: String!
    
    init(age: Int, gender: String, color: String, maritialStatus: String) {
    }//We are calling an initializer method to initialize the variables(by using ‘init’) if someone instantiates it.
    
    func play(sport: String) {//Methods or Functions
    }
    
    func play(instrument: String) {//Method overloading discussed later.
    }
}

// MARK: - Encapsulation
Encapsulation is a concept by which we hide data and methods from outside intervention and usage. Hiding internal data and exposing only necessary functionalities.


// MARK: - Abstraction
Abstraction is an OOP concept by which we expose relevant data and methods of an object hiding their internal implementation.

class Maths {//declare a Maths class which does up some mathematical calculations.
    let a: Int!
    let b: Int!
    private var result: Int?
    
    init(a: Int,b: Int) {
        self.a = a
        self.b = b
    }
    
    func add() {//declare a method to add the two variables
        result = a + b
    }
    
    func displayTotal() {
        print("Result - \(result)")
    }
}

let calculation = Maths(a: 2, b: 3)
calculation.add()
calculation.displayTotal()

In the above example, we encapsulated the variable “result” by using the access specifier “private”. We hide the data of variable “result” from any outside intervention and usage.

In our example in encapsulation, we are exposing displayTotal() and add() method to the user to perform the calculations, but hiding the internal calculations.


// MARK: - Inheritance
Inheritance is defined as a process by which you inherit the properties of your parent. Technically, Inheritance is a process by which a child class inherits the properties of its parent class.

class Men: Person {
    override init(age: Int, gender: String, color: String, maritalStatus: String) {
        super.init(age: age, gender: gender, color: color, maritalStatus: maritalStatus)
    }
}

let andy = Men(age: 25, gender: "Male", color: "White", maritalStatus: "Married")
print(andy.age!)


// MARK: - Method overloading
Method overloading is the process by which a class has two or more methods with same name but different parameters.


// MARK: - Method Overriding
Method Overriding is the process by which two methods have the same method name and parameters. One of the methods is in the parent class and the other is in the child class.

class Men: Person {//declare a child class Men which inherits the Person class
    
    override init(age: Int, gender: String, color: String, maritialStatus: String) {
        //initialise men
        super.init(age: age, gender: gender, color: color, maritialStatus: maritialStatus)
    }
}

let andy = Men(age: 2, gender: "M", color: "White", maritialStatus: "M")
print(andy.age) // And since Men class inherits from Person parent class, it can also access its properties as it does in the code.


// MARK: - Polyymorphism
The ability to treat different objects of different classes through the same interface.

class Animal {
    func makeSound() {
        print("Animal makes a sound")
    }
}

class Dog: Animal {
    override func makeSound() {
        print("Dog barks")
    }
}

class Cat: Animal {
    override func makeSound() {
        print("Cat meows")
    }
}

let animals: [Animal] = [Dog(), Cat(), Animal()]

for animal in animals {
    animal.makeSound()  // Demonstrates Polymorphism
}

Using the same interface (Animal), we invoke different behaviors based on the actual object (Dog, Cat, or Animal). This is runtime polymorphism in action.








⭐ If you found this helpful, please consider giving this repository a star!
