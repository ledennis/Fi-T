//
//  WorkoutTableViewController.swift
//  Fi-T
//
//  Created by Dennis Le on 4/2/18.
//  Copyright © 2018 Dennis Le. All rights reserved.
//

import UIKit
import os.log

class WorkoutTableViewController: UITableViewController {
    
    @IBOutlet weak var workoutDayTitle: UINavigationItem!
    @IBOutlet weak var workoutLabels: UILabel!
    //MARK: Properties
    
    var workouts = [Workout]()
    var pushDay = WorkoutDay(name: "Push", workoutsArray: [])
    var pullDay = WorkoutDay(name: "Pull", workoutsArray: [])
    var legDay = WorkoutDay(name: "Leg", workoutsArray: [])
    
    var workoutManager = WorkoutDayManager(workoutDays:[])

    override func viewDidLoad() {
        super.viewDidLoad()

        workoutLabels.layer.borderWidth = 0.25
        
        workoutManager = WorkoutDayManager(workoutDays:[pushDay!, pullDay!, legDay!])
        workouts = workoutManager.currentWorkoutDay.workoutsArray
        workoutDayTitle.title = workoutManager.currentWorkoutDay.name
        
        // Load any saved workouts.
        if let savedWorkouts = loadWorkouts() {
            workouts += savedWorkouts
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private Methods
    
    private func saveWorkouts() {
        workoutManager.currentWorkoutDay.saveWorkouts(workoutsArray: workouts)
    }
    
    private func loadWorkouts() -> [Workout]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: (workoutManager.currentWorkoutDay.ArchiveURL?.path)!) as? [Workout]
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //MARK: Button Actions
    
    @IBAction func leftButtonAction(_ sender: Any) {
        workoutManager.prevWorkoutDay()
        workouts = workoutManager.loadWorkouts()!
        workoutDayTitle.title = workoutManager.currentWorkoutDay.name
        self.tableView.reloadData()
    }
    
    @IBAction func rightButtonAction(_ sender: Any) {
        workoutManager.nextWorkoutDay()
        workouts = workoutManager.loadWorkouts()!
        workoutDayTitle.title = workoutManager.currentWorkoutDay.name
        self.tableView.reloadData()
    }
    
    
    //MARK: Actions
    
    @IBAction func unwindToWorkoutList(sender: UIStoryboardSegue) {
        if let source = sender.source as? AddWorkoutViewController, let workout = source.workout {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing workout.
                workouts[selectedIndexPath.row] = workout
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new workout.
                let newIndexPath = IndexPath(row: workouts.count, section: 0)
                
                workouts.append(workout)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            saveWorkouts()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return workouts.count
    }
    
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .none
//    }
//    
//    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "WorkoutTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkoutTableViewCell else {
            fatalError("The dequeued cell is not an instance of WorkoutTableViewCell.")
        }
        
        let workout = workouts[indexPath.row]
        
        cell.nameLabel.text = workout.name
        cell.setsLabel.text = workout.sets
        cell.weightLabel.text = workout.weight
        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets.zero

        return cell
    }
    
    // Override to support moving rows in edit mode.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.workouts[sourceIndexPath.row]
        workouts.remove(at: sourceIndexPath.row)
        workouts.insert(movedObject, at: destinationIndexPath.row)
        saveWorkouts()
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(workouts)")
        self.tableView.reloadData()
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            workouts.remove(at: indexPath.row)
            saveWorkouts()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "AddItem":
                os_log("Adding a new workout.", log: OSLog.default, type: .debug)
            
            case "ShowDetail":
                guard let workoutDetailViewController = segue.destination as? AddWorkoutViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
            
                guard let selectedWorkoutCell = sender as? WorkoutTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
            
                guard let indexPath = tableView.indexPath(for: selectedWorkoutCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
            
                let selectedWorkout = workouts[indexPath.row]
                workoutDetailViewController.workout = selectedWorkout
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

}
