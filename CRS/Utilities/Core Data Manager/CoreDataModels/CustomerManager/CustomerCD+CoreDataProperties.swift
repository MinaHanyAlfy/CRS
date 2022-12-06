//
//  CustomerCD+CoreDataProperties.swift
//  
//
//  Created by John Doe on 2022-12-06.
//
//

import Foundation
import CoreData


extension CustomerCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomerCD> {
        return NSFetchRequest<CustomerCD>(entityName: "CustomerCD")
    }

    @NSManaged public var customerID: String?
    @NSManaged public var customerLatitude: String?
    @NSManaged public var customerLongitude: String?
    @NSManaged public var customerName: String?
    @NSManaged public var customerPotential: String?
    @NSManaged public var customerPrescription: String?
    @NSManaged public var pharmacy: String?
    @NSManaged public var specialityName: String?
    @NSManaged public var zoneName: String?

}
