//
//  KeyCD+CoreDataProperties.swift
//  
//
//  Created by John Doe on 2022-12-06.
//
//

import Foundation
import CoreData


extension KeyCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KeyCD> {
        return NSFetchRequest<KeyCD>(entityName: "KeyCD")
    }

    @NSManaged public var keyPersonID: String?
    @NSManaged public var keyPersonName: String?
    @NSManaged public var mobile: String?
    @NSManaged public var specialityName: String?
    @NSManaged public var accountID: String?

}
