//
//  WorkoutDay.swift
//  Fi-T
//
//  Created by Dennis Le on 6/10/18.
//  Copyright © 2018 Dennis Le. All rights reserved.
//

import UIKit
import os.log

class WorkoutDay {
    
    //MARK: Archiving Paths
    
    let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    var ArchiveURL = URL(string: "")
    
    //MARK: Properties
    
    var name: String
    var workoutsArray: [Workout]
    
    init?(name: String, workoutsArray: [Workout]) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        ArchiveURL = DocumentsDirectory.appendingPathComponent(name)
        self.name = name
        self.workoutsArray = workoutsArray
    }
    
    func saveWorkouts(workoutsArray: [Workout]) {
        if ArchiveURL != URL(string: "") {
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(workoutsArray, toFile: (ArchiveURL?.path)!)
            self.workoutsArray = workoutsArray

            if isSuccessfulSave {
                os_log("Workouts successfully saved.", log: OSLog.default, type: .debug)
            } else {
                os_log("Failed to save workouts...", log: OSLog.default, type: .error)
            }
        } else {
            os_log("Archive Path is incorrect.", log: OSLog.default, type: .debug)
        }
    }
}
