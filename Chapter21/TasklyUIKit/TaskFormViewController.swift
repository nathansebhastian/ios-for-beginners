//
//  TaskFormViewController.swift
//  TasklyUIKit
//
//  Created by Nathan Sebhastian on 08/10/24.
//

import UIKit

class TaskFormViewController: UIViewController {

    @IBOutlet var taskTitle: UITextField!
    @IBOutlet var taskStatus: UISwitch!

    var newTask: TaskItem?
    var taskToEdit: TaskItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let task = taskToEdit {
            taskTitle.text = task.title
            taskStatus.isOn = task.isCompleted
        }
    }
        
    @IBAction func didTapSaveTask(_ sender: UIBarButtonItem) {
        if validate {
            performSegue(withIdentifier: "unwindToTaskList", sender: self)
        } else {
            let alert = UIAlertController(title: "Validation Error", message: "Task Title cannot be empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    var validate: Bool {
        guard taskTitle.text?.trimmingCharacters(in: .whitespaces).isEmpty != true
        else {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToTaskList" {
            let title = taskTitle.text ?? ""
            let isCompleted = taskStatus.isOn
            if let task = taskToEdit {
                task.title = title
                task.isCompleted = isCompleted
            } else {
                newTask = TaskItem(title: title, isCompleted: isCompleted)
            }
        }
    }

}
