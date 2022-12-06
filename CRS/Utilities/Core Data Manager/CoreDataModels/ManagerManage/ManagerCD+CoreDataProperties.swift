//
//  ManagerCD+CoreDataProperties.swift
//  
//
//  Created by John Doe on 2022-12-06.
//
//

import Foundation
import CoreData


extension ManagerCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagerCD> {
        return NSFetchRequest<ManagerCD>(entityName: "ManagerCD")
    }

    @NSManaged public var id: String?
    @NSManaged public var level: String?
    @NSManaged public var name: String?

}
