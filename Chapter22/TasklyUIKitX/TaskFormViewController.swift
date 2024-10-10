//
//  TaskFormViewController.swift
//  TasklyUIKitX
//
//  Created by Nathan Sebhastian on 08/10/24.
//

import UIKit

protocol TaskFormDelegate: AnyObject {
    func saveTask(_ newTask: TaskItem)
}

class TaskFormViewController: UIViewController {
    
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
            let newTask = TaskItem(title: title, isCompleted: isCompleted)
            delegate?.saveTask(newTask)
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
