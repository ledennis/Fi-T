//
//  Workout.swift
//  Fi-T
//
//  Created by Dennis Le on 4/29/18.
//  Copyright © 2018 Dennis Le. All rights reserved.
//

import UIKit
import os.log

class Workout: NSObject, NSCoding {
    
    struct PropertyKey {
        static let name = "name"
        static let sets = "sets"
        static let weight = "weight"
    }
    
    //MARK: Properties
    
    var name: String
    var sets: String
    var weight: String
    
    init?(name: String, sets: String, weight: String) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.sets = sets
        self.weight = weight
        
    }
    
    //MARK: Archiving Paths
    
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("workouts")
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(sets, forKey: PropertyKey.sets)
        aCoder.encode(weight, forKey: PropertyKey.weight)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // The sets are required. If we cannot decode a name string, the initializer should fail.
        guard let sets = aDecoder.decodeObject(forKey: PropertyKey.sets) as? String else {
            os_log("Unable to decode the sets for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // The weight is required. If we cannot decode a name string, the initializer should fail.
        guard let weight = aDecoder.decodeObject(forKey: PropertyKey.weight) as? String else {
            os_log("Unable to decode the weight for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, sets: sets, weight: weight)
    }
}
