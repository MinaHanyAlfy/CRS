//
//  CoreDataManager.swift
//  CRS
//
//  Created by John Doe on 2022-12-05.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let userDef = UserDefaults.standard
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    func context() ->  NSManagedObjectContext {
        let context = appDelegate().persistentContainer.viewContext
        return context
    }
    
    func save() {
        appDelegate().saveContext()
    }
    
    func clearAll() {
        clearUserInfo()
        clearKeys()
        clearAccounts()
        clearManagers()
        clearPharmacy()
        clearProducts()
        clearCustomers()
    }
}



//MARK: - USER INFO UserDefults
extension CoreDataManager {
    func saveUserInfo(user: User) {
        userDef.set(user.id, forKey: "id")
        userDef.set(user.name, forKey: "name")
        userDef.set(user.company?.name, forKey: "companyName")
        userDef.set(user.company?.title, forKey: "companyTitle")
        userDef.set(user.company?.address, forKey: "companyAddress")
        userDef.set(user.company?.latitude, forKey: "companyLat")
        userDef.set(user.company?.longitude, forKey: "companyLong")
        userDef.set(user.company?.pass, forKey: "companyPass")
        userDef.set(user.company?.retrospectiveReport, forKey: "companyRetro")
        userDef.set(user.company?.serial, forKey: "companySerial")
        userDef.set(user.company?.tel, forKey: "companyTel")
    }
    
    func clearUserInfo() {
        userDef.removeObject(forKey: "id")
        userDef.removeObject(forKey: "name")
        userDef.removeObject(forKey: "companyName")
        userDef.removeObject(forKey: "companyTitle")
        userDef.removeObject(forKey: "companyAddress")
        userDef.removeObject(forKey: "companyLong")
        userDef.removeObject(forKey: "companyLat")
        userDef.removeObject(forKey: "companyPass")
        userDef.removeObject(forKey: "companyRetro")
        userDef.removeObject(forKey: "companySerial")
        userDef.removeObject(forKey: "companyTel")
    }
    
    func getUserInfo() -> User {
        let user = User(name: userDef.value(forKey: "name")  as? String, id:  userDef.value(forKey: "id") as? String, company: CompanyElement(serial: userDef.value(forKey: "companySerial") as? String, name: userDef.value(forKey: "companyName") as? String, pass: userDef.value(forKey: "companyPass") as? String, title: userDef.value(forKey: "companyTitle") as? String, address:  userDef.value(forKey: "companyAddress") as? String, latitude: userDef.value(forKey: "companyLat") as? String, longitude: userDef.value(forKey: "companyLong") as? String, tel: userDef.value(forKey: "companyTel") as? String, retrospectiveReport:  userDef.value(forKey: "companyRetro") as? String))
        return user
    }
    func isLogin() -> Bool {
        return userDef.value(forKey: "id") != nil
    }
}
