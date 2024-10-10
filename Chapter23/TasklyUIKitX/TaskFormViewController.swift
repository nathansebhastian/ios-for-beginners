//
//  TaskFormViewController.swift
//  TasklyUIKitX
//
//  Created by Nathan Sebhastian on 08/10/24.
//

import UIKit
import CoreData

protocol TaskFormDelegate: AnyObject {
    func taskDataChanged()
}

class TaskFormViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var taskToEdit: TaskEntity?
    weak var delegate: TaskFormDelegate?
    
    let taskTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task Title"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let taskStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Completed"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let taskStatusSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Task Form"
        view.backgroundColor = .white
        
        if let task = taskToEdit {
            taskTitleTextField.text = task.title
            taskStatusSwitch.isOn = task.isCompleted
        }
        
        let rightBarButton = UIBarButtonItem(title: "Save Task", style: .plain, target: self, action: #selector(didTapSaveTask))
        navigationItem.rightBarButtonItem = rightBarButton
        
        view.addSubview(taskTitleTextField)
        view.addSubview(taskStatusLabel)
        view.addSubview(taskStatusSwitch)
        setupConstraints()
    }
    
    @objc func didTapSaveTask() {
        if validate {
            let title = taskTitleTextField.text ?? ""
            let isCompleted = taskStatusSwitch.isOn
            if let task = taskToEdit {
                updateTask(taskToUpdate: task, taskTitle: title, taskStatus: isCompleted)
            } else {
                createTask(taskTitle: title, taskStatus: isCompleted)
            }
            delegate?.taskDataChanged()
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Validation Error", message: "Task Title cannot be empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    var validate: Bool {
        guard taskTitleTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty != true
        else {
            return false
        }
        return true
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Text Field constraints
            taskTitleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            taskTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Label constraints
            taskStatusLabel.topAnchor.constraint(equalTo: taskTitleTextField.bottomAnchor, constant: 20),
            taskStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Switch constraints
            taskStatusSwitch.centerYAnchor.constraint(equalTo: taskStatusLabel.centerYAnchor),
            taskStatusSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

}

extension TaskFormViewController {
    func createTask(taskTitle: String, taskStatus: Bool) {
        let newTask = TaskEntity(context: context)
        newTask.title = taskTitle
        newTask.isCompleted = taskStatus
        
        do {
            try context.save()
        } catch {
            print("Failed to save task: \(error)")
        }
    }
    
    func updateTask(taskToUpdate: TaskEntity, taskTitle: String, taskStatus: Bool){
        taskToUpdate.title = taskTitle
        taskToUpdate.isCompleted = taskStatus
        
        do {
            try context.save()
        } catch {
            print("Failed to update task: \(error)")
        }
    }
}
