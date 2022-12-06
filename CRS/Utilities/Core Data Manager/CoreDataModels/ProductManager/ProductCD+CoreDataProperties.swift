//
//  ProductCD+CoreDataProperties.swift
//  
//
//  Created by John Doe on 2022-12-06.
//
//

import Foundation
import CoreData


extension ProductCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductCD> {
        return NSFetchRequest<ProductCD>(entityName: "ProductCD")
    }

    @NSManaged public var productID: String?
    @NSManaged public var productName: String?

}
