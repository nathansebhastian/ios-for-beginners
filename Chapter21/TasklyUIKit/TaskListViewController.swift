//
//  ViewController.swift
//  TasklyUIKit
//
//  Created by Nathan Sebhastian on 02/10/24.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tasks: [TaskItem] = [
        TaskItem(title: "Learn Swimming", isCompleted: false),
        TaskItem(title: "Learn Storyboard", isCompleted: true),
        TaskItem(title: "Learn UIKit", isCompleted: false)
    ]
    
    @IBOutlet var taskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! SingleTaskCell
        
        cell.task = tasks[indexPath.row]
        cell.toggleCompletion = { [weak self] in
            self?.tasks[indexPath.row].isCompleted.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (_, _, completionHandler) in
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {
            (_, _, completionHandler) in
            
            self.performSegue(withIdentifier: "taskFormSegue", sender: indexPath)
            completionHandler(true)
        }
        
        editAction.backgroundColor = UIColor(.green)
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [editAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false

        return swipeConfiguration
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskFormSegue" {
            if let destinationVC = segue.destination as? TaskFormViewController,
               let indexPath = sender as? IndexPath {
                destinationVC.taskToEdit = tasks[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToTaskList(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? TaskFormViewController {
            if let newTask = sourceViewController.newTask {
                tasks.append(newTask)
                taskTableView.reloadData()
            } else if sourceViewController.taskToEdit != nil {
                taskTableView.reloadData()
            }
        }
    }
}

