//
//  CustomerCoreDataManager.swift
//  CRS
//
//  Created by John Doe on 2022-12-06.
//

import UIKit
import CoreData

//MARK: - Key Table Info
extension CoreDataManager {
    func saveCustomers(customers: Customers) {
        for customer in customers {
            let customerCD = CustomerCD(context: context())
            customerCD.specialityName = customer.specialityName
            customerCD.zoneName = customer.zoneName
            customerCD.customerName = customer.customerName
            customerCD.customerID = customer.customerID
            customerCD.pharmacy = customer.pharmacy
            customerCD.customerLatitude = customer.customerLatitude
            customerCD.customerLongitude = customer.customerLongitude
            customerCD.customerPotential =  customer.customerPotential
            customerCD.customerPrescription = customer.customerPrescription
            do {
                try context().save()
                print("✅ Success")
            } catch let error as NSError {
                print(error)
            }
        }
        
    }
    
    func clearCustomers() {
        let context = context()
        let fetchRequest: NSFetchRequest<CustomerCD> = CustomerCD.fetchRequest()
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
    
    func getCustomers () -> Customers {
        let context = context()
        let fetchRequest: NSFetchRequest<CustomerCD> = CustomerCD.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        var customers: Customers = []
        for objc in objects {
            let customer = Customer(customerID: objc.customerID, customerName: objc.customerName, customerPotential: objc.customerPotential, customerPrescription: objc.customerPrescription, pharmacy: objc.pharmacy, customerLatitude: objc.customerLatitude, customerLongitude: objc.customerLongitude, specialityName: objc.specialityName, zoneName: objc.zoneName)
            customers.append(customer)
        }
        return customers
    }
}
