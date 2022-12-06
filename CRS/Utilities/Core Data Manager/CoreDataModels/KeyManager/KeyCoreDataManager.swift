//
//  KeyCoreDataManager.swift
//  CRS
//
//  Created by John Doe on 2022-12-06.
//

import UIKit
import CoreData

//MARK: - Key Table Info
extension CoreDataManager {
    func saveKeys(keys: Keys) {
        for key in keys {
            let keyCD = KeyCD(context: context())
            keyCD.accountID = key.accountID
            keyCD.specialityName = key.specialityName
            keyCD.keyPersonID = key.keyPersonID
            keyCD.keyPersonName = key.keyPersonName
            keyCD.mobile = key.mobile
            do {
                try context().save()
                print("✅ Success")
            } catch let error as NSError {
                print(error)
            }
        }
        
    }
    
    func clearKeys() {
        let context = context()
        let fetchRequest: NSFetchRequest<KeyCD> = KeyCD.fetchRequest()
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
    
    func getKeys () -> Keys {
        let context = context()
        let fetchRequest: NSFetchRequest<KeyCD> = KeyCD.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        var keys: Keys = []
        for objc in objects {
            let key = Key(keyPersonID: objc.keyPersonID, keyPersonName: objc.keyPersonName, specialityName: objc.specialityName, mobile: objc.mobile, accountID: objc.accountID)
            keys.append(key)
        }
        return keys
    }
}
