//
//  Meal.swift
//  FoodTracker
//
//  Created by Winnie Hou on 2020-01-28.
//  Copyright © 2020 Winnie Hou. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    
    var name: String
    var photo: UIImage?
    let rating: Int

    // MARK: Archiving Paths
    // static meas: belong to class, instead of an instance of class. Same as Java static keyword
    // outside the Meal class, the path can be access via syntax Meal.ArchiveURL.path
    // use DocumentsDirectory to determine the URL which the App can reach and store data. pick the first element in the array of URL!
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // create the URL for app's data. the directory will be URL/meals
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    // MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    // Failable initializers: init? or init!
    // init? return optional value
    // init! return implicitly unwrapped optional values
    // Optional: can either contain a valid or nil.
    // need check to see if the optional has a value, and then safely unwrap th value before you can use it.
    // Implicitly unwrapped optional are optional, but the system implicitly unwraps them for you
    // Failable initializer is not easy to use. Developer prefer to use assert(_:_:file:line:) and precondition(_:_:file:line:)
    init?(name: String, photo: UIImage?, rating:Int) {
        // Initialization should fail if there is no name or if the rating is negative.
        // Use guard to replace if statement
        //if name.isEmpty || rating < 0 {
        //    return nil
        //}
        
        //if rating < 0 || rating > 5 {
        //    return nil
        //}

        guard !name.isEmpty else {
            return nil
        }
        
        guard (rating>=0) && (rating<=5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    // MARK: NSCoding
    // encode the value of each property on the Meal class, and store them with their correcsponding key.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    // Required means: the subclasses need to implement the initializer.
    // Convenience means: this is a secondary initializer, and it must call a designated initializer from the same class
    // ? means: this is a failable initializer, might return "nil"
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // No guard needed here because photo is optional
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        // Return value of decode as Int
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        //Must call designed initializer.
        self.init(name:name, photo:photo, rating:rating)
    }
}




