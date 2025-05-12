
Access Levels in swift are:

-- private, fileprivate, internal, public, open --
also explained the use of 'final' keyword.

// MARK: - private

private:- Private access restricts the use of an entity to the enclosing declaration, and to extensions of that declaration that are in the same file.
    Note that the extension still has to be in the same source file for private access.
    
    Not accesible even in subclasses.

    Use private access to hide the implementation details of a specific piece of functionality when those details are used only within a single declaration.

// MARK: - file private
                                                                            
File-private:- File-private access restricts the use of an entity to its own defining source file. Use file-private access to hide the implementation details of a specific piece of functionality when those details are used within an entire file.

    So basically a variable declared as filePrivate in one class (of a specific file) can be accessed by another class/ classes defined in the same file only. Not outside that file.
                                                                            
                                                                    
// MARK: - internal

Internal:- Internal access enables entities to be used within any source file from their defining module, but not in any source file outside of that module. You typically use internal access when defining an app’s or a framework’s internal structure.

    So basically a variable( internal by default ) defined in one class can be accessed in any other file (of the same project/ module) by instantiating an instance of that class.
    
    Ex:

        class A {
            var name: String?
            init(namee: String){
                self.name = namee
            }
        }
 
        Here variable name can be accessed in another class B like so

        class B {
            func getName(){
                let a = A(namee: "Hari")
                print(a.name ?? "")
            }
        }

// MARK: - open , public

Open access and public access enable entities to be used within any source file from their defining module, and also in a source file from another module that imports the defining module. You typically use open or public access when specifying the public interface to a framework. The difference between open and public access is described below.

    Open access applies only to classes and class members, and it differs from public access by allowing code outside the module to subclass and override.
    i.e, to say,
    open you can access open classes and class members from any source file in the defining module or any module that imports that module. You can subclass an open class or override an open class member both within their defining module and any module that imports that module.

    public allows the same access as open - any source file in any module - but has more restrictive subclassing and overriding. You can only subclass a public class within the same module. A public class member can only be overriden by subclasses in the same module. This is important if you are writing a framework. If you want a user of that framework to be able to subclass a class or override a method you must make it open.
                                                                            
    Remember: With 'Public',No subclassing and overriding from another module . Important difference between public and open.

//MARK: - final
                                                                        
•    Prevents subclassing and overriding of classes, methods, and properties.
•    Can be used with any access level except open.
•    Often applied to classes like UIViewController to improve performance by allowing the compiler to optimize dispatching.
"""

You can add final to any access level, except open, to prevent subclassing or overriding of a class method or property.

Have also heard that using final appropriately can sometime speed up the code execution like that of a viewcontroller..

"""


⭐ If you found this helpful, please consider giving this repository a star!
