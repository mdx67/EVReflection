//
//  EVObject.swift
//
//  Created by Edwin Vermeer on 5/2/15.
//  Copyright (c) 2015 evict. All rights reserved.
//

import Foundation

/**
Object that will support NSCoding, Printable, Hashable and Equeatable for all properties. Use this object as your base class instead of NSObject and you wil automatically have support for all these protocols.
*/
public class EVObject: NSObject, NSCoding, CustomDebugStringConvertible { // These are redundant in Swift 2: CustomStringConvertible, Hashable, Equatable
    
    /**
    Basic init override is needed so we can use EVObject as a base class.
    */
    public required override init(){
        super.init()
    }
    
    /**
    Decode any object
    
    - parameter theObject: The object that we want to decode.
    - parameter aDecoder: The NSCoder that will be used for decoding the object.
    */
    public convenience required init?(coder: NSCoder) {
        self.init()
        EVReflection.decodeObjectWithCoder(self, aDecoder: coder)
    }
    
    /**
    Encode this object using a NSCoder
    
    - parameter aCoder: The NSCoder that will be used for encoding the object
    */
    final public func encodeWithCoder(aCoder: NSCoder) {
        EVReflection.encodeWithCoder(self, aCoder: aCoder)
    }
    
    /**
    Returns the pritty description of this object
    
    :return: The pritty description
    */
    final public override var description: String {
        get {
            return EVReflection.description(self)
        }
    }
    
    /**
    Returns the pritty description of this object
    
    :return: The pritty description
    */
    final public override var debugDescription: String {
        get {
            return EVReflection.description(self)
        }
    }
    
    /**
    Returns the hashvalue of this object
    
    :return: The hashvalue of this object
    */
    public override var hashValue: Int {
        get {
            return EVReflection.hashValue(self)
        }
    }
    
    /**
    Function for returning the hash for the NSObject based functionality
    
    :return: The hashvalue of this object
    */
    final public override var hash: Int {
        get {
            return self.hashValue
        }
    }
    
    /**
    Implementation of the NSObject isEqual comparisson method
    
    - parameter object: The object where you want to compare with
    :return: Returns true if the object is the same otherwise false
    */
    final public override func isEqual(object: AnyObject?) -> Bool { // for isEqual:
        if let dataObject = object as? EVObject {
            return dataObject == self // just use our "==" function
        } else { return false }
    }
    
    /**
    Implementation of the setValue forUndefinedKey so that we can catch exceptions for when we use an optional Type like Int? in our object. Instead of using Int? you should use NSNumber?
    
    - parameter value: The value that you wanted to set
    - parameter key: The name of the property that you wanted to set
    */
    public override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        if let genericSelf = self as? EVGenericsKVC {
            genericSelf.setValue(value, forUndefinedKey: key)
            return
        }
        NSLog("\nWARNING: The class '\(EVReflection.swiftStringFromClass(self))' is not key value coding-compliant for the key '\(key)'\n There is no support for optional type, array of optionals or enum properties.\nAs a workaround you can implement the function 'setValue forUndefinedKey' for this. See the unit tests for more information\n")
    }
    
    /**
    Override this method when you want custom property mapping.
    
    :return: Return an array with valupairs of the object property name and json key name.
    */
    public func propertyMapping() -> [(String?, String?)] {
        return []
    }
}



/**
Protocols created for easy workarounds
*/


/**
Protocol for the workaround when using generics. See WorkaroundSwiftGenericsTests.swift
*/
public protocol EVGenericsKVC {
    func setValue(value: AnyObject!, forUndefinedKey key: String)
}

/**
Protocol for the workaround when using an enum with a rawValue of type Int
*/
public protocol EVRawInt {
    var rawValue: Int { get }
}

/**
Protocol for the workaround when using an enum with a rawValue of type String
*/
public protocol EVRawString {
    var rawValue: String { get }
}

/**
Protocol for the workaround when using an enum with a rawValue of an undefined type
*/
public protocol EVRaw {
    var anyRawValue: AnyObject { get }
}

/**
Protocol for the workaround when using an array with nullable values
*/
public protocol EVArrayConvertable {
    func convertArray(key: String, array: Any) -> NSArray
}








