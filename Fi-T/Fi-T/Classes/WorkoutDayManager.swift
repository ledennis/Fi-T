//
//  WorkoutDayManager.swift
//  Fi-T
//
//  Created by Dennis Le on 6/10/18.
//  Copyright © 2018 Dennis Le. All rights reserved.
//

import UIKit
import os.log

class WorkoutDayManager {
    
    
    //MARK: Properties
    
    var workoutDays: [WorkoutDay]
    var arrayTracker: Int
    var currentWorkoutDay: WorkoutDay
    
    init(workoutDays: [WorkoutDay]) {
        
        // Initialize stored properties.
        self.workoutDays = workoutDays
        self.arrayTracker = 0
        if (!workoutDays.isEmpty) {
            self.currentWorkoutDay = workoutDays[arrayTracker]
        } else {
            self.currentWorkoutDay = WorkoutDay(name:"Test" , workoutsArray: [])!
        }
    }
    
    func nextWorkoutDay() {
        if (arrayTracker == workoutDays.count-1) {
            arrayTracker = 0
        } else {
            arrayTracker += 1
        }
        
        currentWorkoutDay = workoutDays[arrayTracker]
    }
    
    func prevWorkoutDay() {
        if (arrayTracker == 0) {
            arrayTracker = workoutDays.count-1
        } else {
            arrayTracker -= 1
        }
        
        currentWorkoutDay = workoutDays[arrayTracker]
    }
    
    func loadWorkouts() -> [Workout]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: (currentWorkoutDay.ArchiveURL?.path)!) as? [Workout]
    }
}
