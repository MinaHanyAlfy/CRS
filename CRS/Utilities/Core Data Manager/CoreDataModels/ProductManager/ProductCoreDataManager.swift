//
//  ProductCoreDataManager.swift
//  CRS
//
//  Created by John Doe on 2022-12-06.
//

import UIKit
import CoreData

//MARK: - Product Table Info
extension CoreDataManager {
    func saveProducts(products: Products) {
        for product in products {
            let productCD = ProductCD(context: context())
            productCD.productID = product.productID
            productCD.productName = product.productName
            
            do {
                try context().save()
                print("✅ Success")
            } catch let error as NSError {
                print(error)
            }
        }
        
    }
    
    func clearProducts() {
        let context = context()
        let fetchRequest: NSFetchRequest<ProductCD> = ProductCD.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        for obj in objects {
            context.delete(obj)
        }
        
        do {
            try context.save()
        } catch {
            print("❌ Error Delete Object")
        }
    }
    
    func getProducts () -> Products {
        let context = context()
        let fetchRequest: NSFetchRequest<ProductCD> = ProductCD.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        var products: Products = []
        for objc in objects {
            let product = Product(productID: objc.productID, productName: objc.productName)
            products.append(product)
        }
        return products
    }
}
