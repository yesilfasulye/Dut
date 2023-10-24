//
//  Notes+CoreDataProperties.swift
//  Dut
//
//  Created by Burak Kaya on 12.11.2022.
//
//

import Foundation
import CoreData


extension Notes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notes> {
        return NSFetchRequest<Notes>(entityName: "Notes")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    
    var wrappedId: UUID { id ?? UUID() }
    var wrappedContent: String { content! }
    var wrappedDate: Date { date ?? Date() }
    
}

extension Notes : Identifiable {

}
