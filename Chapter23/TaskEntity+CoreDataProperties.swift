//
//  TaskEntity+CoreDataProperties.swift
//  TasklyUIKitX
//
//  Created by Nathan Sebhastian on 09/10/24.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?

}

extension TaskEntity : Identifiable {

}
