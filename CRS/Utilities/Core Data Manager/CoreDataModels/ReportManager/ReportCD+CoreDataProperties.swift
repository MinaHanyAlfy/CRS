//
//  ReportCD+CoreDataProperties.swift
//  CRS
//
//  Created by John Doe on 2023-03-25.
//
//

import Foundation
import CoreData


extension ReportCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReportCD> {
        return NSFetchRequest<ReportCD>(entityName: "ReportCD")
    }

    @NSManaged public var url: String?

}

extension ReportCD : Identifiable {

}
