//
//  PharmacyCD+CoreDataProperties.swift
//  
//
//  Created by John Doe on 2022-12-06.
//
//

import Foundation
import CoreData


extension PharmacyCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PharmacyCD> {
        return NSFetchRequest<PharmacyCD>(entityName: "PharmacyCD")
    }

    @NSManaged public var address: String?
    @NSManaged public var customerID: String?
    @NSManaged public var pharmacyID: String?
    @NSManaged public var pharmacyName: String?
    @NSManaged public var phone: String?

}
