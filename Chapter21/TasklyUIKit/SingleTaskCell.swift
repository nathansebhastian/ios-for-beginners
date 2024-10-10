//
//  SingleTaskCell.swift
//  TasklyUIKit
//
//  Created by Nathan Sebhastian on 08/10/24.
//

import UIKit

class SingleTaskCell: UITableViewCell {
    
    @IBOutlet weak var taskStatus: UIButton!
    @IBOutlet weak var taskTitle: UILabel!
    
    var task: TaskItem? {
        didSet {
            guard let task = task else { return }
            taskTitle.text = task.title
            let imageName = task.isCompleted ? "checkmark.circle.fill" : "circle"
            taskStatus.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    var toggleCompletion: (() -> Void)?
    
    @IBAction func didTapTaskStatus(_ sender: Any) {
        toggleCompletion?()
    }
}
