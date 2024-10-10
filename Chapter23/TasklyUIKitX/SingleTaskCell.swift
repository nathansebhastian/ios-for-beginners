//
//  SingleTaskCell.swift
//  TasklyUIKitX
//
//  Created by Nathan Sebhastian on 10/10/24.
//

import UIKit

class SingleTaskCell: UITableViewCell {

    var taskTitle = UILabel()
    var taskStatus =  UIButton()
    
    var task: TaskEntity? {
        didSet {
            guard let task = task else { return }
            taskTitle.text = task.title
            let imageName = task.isCompleted ? "checkmark.circle.fill" : "circle"
            taskStatus.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    var toggleCompletion: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        taskStatus.addTarget(self, action: #selector(didTaptaskStatus), for: .touchUpInside)
        
        contentView.addSubview(taskTitle)
        contentView.addSubview(taskStatus)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTaptaskStatus() {
        toggleCompletion?()
    }
    
    func setupConstraints() {
        taskTitle.translatesAutoresizingMaskIntoConstraints = false
        taskStatus.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            taskTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            taskStatus.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            taskStatus.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
