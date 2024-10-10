//
//  ViewController.swift
//  TasklyUIKitX
//
//  Created by Nathan Sebhastian on 08/10/24.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tasks = [TaskEntity]()
    
    let taskListTableView: UITableView = {
        let table = UITableView()
        table.register(SingleTaskCell.self, forCellReuseIdentifier: "taskCell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Task List"
        
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapCreateTask))
        
        navigationItem.rightBarButtonItem = rightBarButton
        
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .systemGray6
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.compactAppearance = appearance
        }
        
        view.addSubview(taskListTableView)
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        fetchTasks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        taskListTableView.frame = view.bounds
    }
    
    @objc func didTapCreateTask() {
        let taskFormVC = TaskFormViewController()
        taskFormVC.title = "Task Form"
        taskFormVC.delegate = self
        navigationController?.pushViewController(taskFormVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskListTableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! SingleTaskCell
        let task = tasks[indexPath.row]
        
        cell.task = task
        cell.toggleCompletion = { [weak self] in
            self?.tasks[indexPath.row].isCompleted.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            do {
                try self?.context.save()
            } catch {
                print("Failed to update task: \(error)")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (_, _, completionHandler) in
            let taskToDelete = self.tasks[indexPath.row]
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.deleteTask(taskToDelete: taskToDelete)
            completionHandler(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {
            (action, sourceView, completionHandler) in
            let taskFormVC = TaskFormViewController()
            taskFormVC.title = "Update Task"
            taskFormVC.taskToEdit = self.tasks[indexPath.row]
            taskFormVC.delegate = self
            self.navigationController?.pushViewController(taskFormVC, animated: true)
            completionHandler(true)
        }
        
        editAction.backgroundColor = UIColor(.green)
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [editAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
}

extension TaskListViewController: TaskFormDelegate {
    func taskDataChanged() {
        fetchTasks()
    }
}

extension TaskListViewController {
    func fetchTasks() {
        do {
            tasks = try context.fetch(TaskEntity.fetchRequest())
            DispatchQueue.main.async {
                self.taskListTableView.reloadData()
            }
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }
    
    func deleteTask(taskToDelete: TaskEntity) {
        context.delete(taskToDelete)
        do {
            try context.save()
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
}
