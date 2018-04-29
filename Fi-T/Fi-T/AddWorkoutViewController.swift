//
//  AddWorkoutViewController.swift
//  Fi-T
//
//  Created by Dennis Le on 4/2/18.
//  Copyright © 2018 Dennis Le. All rights reserved.
//

import UIKit
import os.log

class AddWorkoutViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addWorkoutTF: UITextField!
    @IBOutlet weak var addSetsTF: UITextField!
    @IBOutlet weak var addWeightsTF: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var workout: Workout?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        addWorkoutTF.delegate = self
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = addWorkoutTF.text ?? ""
        let sets = addSetsTF.text ?? ""
        let weight = addWeightsTF.text ?? ""
        
        workout = Workout(name: name, sets: sets, weight: weight)
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = addWorkoutTF.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
