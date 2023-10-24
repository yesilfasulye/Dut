//
//  Task+CoreDataProperties.swift
//  Dut
//
//  Created by Burak Kaya on 7.10.2022.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    
    
    var wrappedID: UUID { id ?? UUID() }
    var wrappedTitle: String { title! }
    var wrappedIsDone: Bool { isDone }
    var wrappedDate: Date { date ?? Date() }

}

extension Task : Identifiable {

}
