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
    
    //MARK: Properties
    
    var workouts = [Workout]()
    
    //MARK: Private Methods
    
    private func loadSampleWorkouts() {
        guard let bench = Workout(name: "Bench", sets:"3 x 10", weight:"225lbs") else {
            fatalError("Unable to instantiate bench")
        }
        
        guard let deadlift = Workout(name: "Deadlift", sets:"5 x 5", weight:"315lbs") else {
            fatalError("Unable to instantiate deadlift")
        }
        
        guard let squat = Workout(name: "Squat", sets:"4 x 8", weight:"185lbs") else {
            fatalError("Unable to instantiate squat")
        }
        
        workouts += [bench, deadlift, squat]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedWorkouts = loadWorkouts() {
            workouts += savedWorkouts
        } else {
            loadSampleWorkouts()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func saveWorkouts() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(workouts, toFile: Workout.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Workouts successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save workouts...", log: OSLog.default, type: .error)
        }
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "WorkoutTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkoutTableViewCell else {
            fatalError("The dequeued cell is not an instance of WorkoutTableViewCell.")
        }
        
        let workout = workouts[indexPath.row]
        
        cell.nameLabel.text = workout.name
        cell.setsLabel.text = workout.sets
        cell.weightLabel.text = workout.weight

        return cell
    }
    
    private func loadWorkouts() -> [Workout]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Workout.ArchiveURL.path) as? [Workout]
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
