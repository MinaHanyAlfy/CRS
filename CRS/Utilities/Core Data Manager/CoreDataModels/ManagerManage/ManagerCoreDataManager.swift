//
//  ManagerCoreDataManager.swift
//  CRS
//
//  Created by John Doe on 2022-12-06.
//

import UIKit
import CoreData

//MARK: - Manager Table Info
extension CoreDataManager {
    func saveManagers(managers: Managers) {
        for manager in managers {
            let managerCD = ManagerCD(context: context())
            managerCD.level = manager.level
            managerCD.id = manager.id
            managerCD.name = manager.name
            do {
                try context().save()
                print("✅ Success")
            } catch let error as NSError {
                print(error)
            }
        }
        
    }
    
    func clearManagers() {
        let context = context()
        let fetchRequest: NSFetchRequest<ManagerCD> = ManagerCD.fetchRequest()
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
    
    func getManagers () -> Managers {
        let context = context()
        let fetchRequest: NSFetchRequest<ManagerCD> = ManagerCD.fetchRequest()
        let objects = try! context.fetch(fetchRequest)
        var managers: Managers = []
        for objc in objects {
            let manager = Manager(the0: nil, the1: nil, the2: nil, level: objc.level, id: objc.id, name: objc.name)
            managers.append(manager)
        }
        return managers
    }
}
