//
//  WorkoutDay.swift
//  Fi-T
//
//  Created by Dennis Le on 6/10/18.
//  Copyright © 2018 Dennis Le. All rights reserved.
//

import UIKit
import os.log

class WorkoutDay: NSObject, NSCoding {
    
    struct PropertyKey {
        static let name = "name"
        static let workoutsArray = "workoutsArray"
    }
    
    //MARK: Properties
    
    var name: String
    var workoutsArray: [Workout]
    
    init?(name: String, workoutsArray: [Workout]) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        guard !workoutsArray.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.workoutsArray = workoutsArray
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("workouts")
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(workoutsArray, forKey: PropertyKey.workoutsArray)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // The workoutsArray are required. If we cannot decode a name string, the initializer should fail.
        guard let workoutsArray = aDecoder.decodeObject(forKey: PropertyKey.workoutsArray) as? [Workout] else {
            os_log("Unable to decode the workoutsArray for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, workoutsArray: workoutsArray)
    }
}
