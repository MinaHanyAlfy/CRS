//
//  AccountsCD+CoreDataProperties.swift
//  CRS
//
//  Created by John Doe on 2022-12-06.
//
//

import Foundation
import CoreData


extension AccountsCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountsCD> {
        return NSFetchRequest<AccountsCD>(entityName: "AccountsCD")
    }

    @NSManaged public var accountID: String?
    @NSManaged public var accountLatitude: String?
    @NSManaged public var accountLongitude: String?
    @NSManaged public var accountName: String?
    @NSManaged public var accountPotential: String?
    @NSManaged public var accountPrescription: String?
    @NSManaged public var keyPerson: String?
    @NSManaged public var specialityName: String?
    @NSManaged public var zoneName: String?

}

extension AccountsCD : Identifiable {

}
