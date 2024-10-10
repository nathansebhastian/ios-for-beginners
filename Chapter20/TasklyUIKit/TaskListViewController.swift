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
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].title
        return cell
    }


}

