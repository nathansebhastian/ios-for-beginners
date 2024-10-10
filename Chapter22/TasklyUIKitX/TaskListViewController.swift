//
//  ViewController.swift
//  TasklyUIKitX
//
//  Created by Nathan Sebhastian on 08/10/24.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasks: [TaskItem] = [
        TaskItem(title: "Learn Swimming", isCompleted: false),
        TaskItem(title: "Learn Storyboard", isCompleted: true),
        TaskItem(title: "Learn UIKit", isCompleted: false)
    ]
    
    let taskListTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "taskCell")
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
        let cell = taskListTableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].title
        
        return cell
    }
}

extension TaskListViewController: TaskFormDelegate {
    func saveTask(_ newTask: TaskItem) {
        print("Save task")
        tasks.append(newTask)
        taskListTableView.reloadData()
    }
}

