//
//  ToDoListitem+CoreDataProperties.swift
//  CoreDataToDo
//
//  Created by Daniel Karath on 10/28/22.
//
//

import Foundation
import CoreData


extension ToDoListitem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListitem> {
        return NSFetchRequest<ToDoListitem>(entityName: "ToDoListitem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoListitem : Identifiable {

}
