//
//  TaskCD+CoreDataProperties.swift
//  
//
//  Created by Kostya Bunsberry on 07.08.2020.
//
//

import Foundation
import CoreData


extension TaskCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCD> {
        return NSFetchRequest<TaskCD>(entityName: "TaskCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var text: String?

}
