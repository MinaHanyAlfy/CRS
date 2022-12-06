//
//  PharmacyCoreDataManager.swift
//  CRS
//
//  Created by John Doe on 2022-12-06.
//

import UIKit
import CoreData

//MARK: - Pharmacy Table Info
extension CoreDataManager {
    func savePharmacy(pharmacies: Pharmacies) {
        for pharmacy in pharmacies {
            let pharmacyCD = PharmacyCD(context: context())
            pharmacyCD.address = pharmacy.address
            pharmacyCD.customerID = pharmacy.customerID
            pharmacyCD.pharmacyID = pharmacy.pharmacyID
            pharmacyCD.pharmacyName = pharmacy.pharmacyName
            pharmacyCD.phone = pharmacy.phone
            do {
                try context().save()
                print("✅ Success")
            } catch let error as NSError {
                print(error)
            }
        }
        
    }
    
    func clearPharmacy() {
        let context = context()
        let fetchRequest: NSFetchRequest<PharmacyCD> = PharmacyCD.fetchRequest()
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
    
    func getPharmacy () -> Pharmacies {
        let context = context()
        let fetchRequest: NSFetchRequest<PharmacyCD> = PharmacyCD.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        var pharmacies: Pharmacies = []
        for objc in objects {
            let pharmacy = Pharmacy(pharmacyID: objc.pharmacyID, pharmacyName: objc.pharmacyName, address: objc.address, phone: objc.phone, customerID: objc.customerID)
            pharmacies.append(pharmacy)
        }
        return pharmacies
    }
}
